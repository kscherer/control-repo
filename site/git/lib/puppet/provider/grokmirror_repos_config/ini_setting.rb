Puppet::Type.type(:grokmirror_repos_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  def section
    resource[:name].split('/', 2).first
  end

  def setting
    resource[:name].split('/', 2).last
  end

  def separator
    '='
  end

  def self.file_path
    '/git/repos.conf'
  end

  # this needs to be removed. This has been replaced with the class method
  def file_path
    self.class.file_path
  end

end
