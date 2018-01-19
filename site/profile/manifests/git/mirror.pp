# Profile for git mirrors
class profile::git::mirror {
  include ::profile::base
  include ::zfs
  Class['profile::common::package_mirrors'] -> Class['zfs']

  # zfs nfs support requires a default mount option in exports
  include nfs::server
  Class['profile::common::package_mirrors'] -> Class['nfs::server']

  # git mirror setup with ZFS
  # The root filesystem is setup on a RAID1 volume, but the disks to be
  # used by ZFS are in "non-RAID" mode: in this case /dev/sdc through /dev/sdn
  #
  # Create gpt label on ZFS disks
  # > for disk in /dev/disk/by-id/ata-ST2000NX0403_S460*; do parted -s $disk mklabel gpt; done
  #
  # Create gpt label on SSDs
  # > for disk in /dev/sdo /dev/sdp; do parted -s $disk mklabel gpt; done
  #
  # Make raidz2 zpool with 2TB disks in slots 2-15 (0,1 are RAID1 root volume)
  # specify ashift because disks are 4K disks
  # specify disks by pci path so when disks are replaced the name stays the same
  # zpool create -o ashift=12 pool raidz2 \
  #   /dev/disk/by-path/pci-0000\:02\:00.0-scsi-0\:0\:[2-9]\:0 \
  #   /dev/disk/by-path/pci-0000\:02\:00.0-scsi-0\:0\:1[0-5]\:0
  #
  # Create mirrored ZIL
  # > parted -s /dev/sdo mkpart primary zfs 1M 5G
  # > parted -s /dev/sdp mkpart primary zfs 1M 5G
  # > zpool add pool log mirror \
  #    '/dev/disk/by-path/pci-0000:02:00.0-scsi-0:0:24:0-part1' \
  #    '/dev/disk/by-path/pci-0000:02:00.0-scsi-0:0:25:0-part1'
  #
  # Create L2ARC
  # > parted -s /dev/sdo mkpart primary zfs 5G 100%
  # > parted -s /dev/sdp mkpart primary zfs 5G 100%
  # > zpool add pool cache \
  #    '/dev/disk/by-path/pci-0000:02:00.0-scsi-0:0:24:0-part2' \
  #    '/dev/disk/by-path/pci-0000:02:00.0-scsi-0:0:25:0-part2'

  # scrub zfs filesystem weekly
  cron {
    'zfs_scrub':
      ensure  => present,
      command => '/sbin/zpool scrub pool',
      user    => 'root',
      weekday => '6', #Saturday
      hour    => '22',
      minute  => '0';
  }

  zfs {
    'pool':
      ensure => present,
      atime  => 'off';
    'pool/git':
      ensure     => present,
      atime      => 'off',
      sharenfs   => 'on',
      mountpoint => '/git',
      setuid     => 'off',
      devices    => 'off';
  }

  include git::user
  include git::service
  file {
    '/git':
      ensure  => directory,
      owner   => 'git',
      group   => 'users',
      require => Zfs['pool/git'];
    '/git/git':
      ensure  => link,
      target  => '.',
      owner   => 'git',
      group   => 'users',
      require => File['/git'];
    '/etc/default/zfs':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      source => 'puppet:///modules/profile/default-zfs';
  }

  # mlocate is a waste for resources
  package {
    'mlocate':
      ensure  => absent,
  }
}
