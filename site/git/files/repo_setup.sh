#!/bin/bash

# Used to setup the repositories on the git mirrors to refuse pushes and
# stop auto gc

repo_setup() {
    local dir=
    for dir in $1;
    do
        if [ -f "$dir/HEAD" ]; then
            (
                cd "$dir"
                if [ ! -f hooks/pre-receive ]; then
                    echo "Setup pre-receive refuse hook to deny pushes on $dir"
                    cat << END > hooks/pre-receive
#!/bin/sh
echo **** ERROR: This repository does not accept pushes because it is a mirror.
exit 1
END
                    chmod +x hooks/pre-receive
                    rm -f hooks/*.sample
                fi

                local auto=$(git config gc.auto)
                if [ "$auto" == "0" ]; then
                    echo "Disabling auto gc on $dir"
                    git config gc.auto 1
                fi
            )
        fi
    done
}

GITDIRS=(-name objects -o -name hooks -o -name refs -o -name branches -o -name info)
base_repos=$(find -L /git/ \( "${GITDIRS[@]}" -o -name logs \) -prune -o -type d -print )

repo_setup "$base_repos"
