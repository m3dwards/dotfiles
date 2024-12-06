#!/usr/bin/fish

function bitcoin_backport_check
    argparse "h/help" "b/base-pr=" "p/prs=" -- $argv
    or return 1

    if set -ql _flag_help
        echo ""
        echo "Usage: bitcoin-backport-check --base-pr=<base-pr> --prs=31301,31302,31303"
        echo "  e.g. bitcoin-backport-check --base-pr=32301 --prs=31301,31302,31303"
        echo ""
        echo "Checks to see that commits from PRs are represented in this backport"
        echo "Diff between commits in current branch and their 'Rebased-From' counterparts in <base-branch>."
        return 0
    end

    # Check if base branch argument is given
    if not set -ql _flag_base_pr
        echo "Error: Missing required --base-pr argument."
        echo "Run 'bitcoin-backport-check --help' for usage information."
        return 1
    end

    # Check if base branch argument is given
    if not set -ql _flag_prs
        echo "Error: Missing required --prs argument."
        echo "Run 'bitcoin-backport-check --help' for usage information."
        return 1
    end

    # Ensure gh CLI is available
    if not command -v gh > /dev/null
        echo "Error: GitHub CLI (gh) is not installed."
        return 1
    end

    set -l backport_commits (gh pr view $_flag_base_pr --repo=bitcoin/bitcoin --json commits --jq '.commits[]')

    echo -e "Checking commits mentioned in the comment are present in the backport PR\n"


    set -l prs (string split ',' $_flag_prs)

    for pr in $prs
        echo "Checking PR: $pr"
        set -l pr_commits (gh pr view $pr --repo=bitcoin/bitcoin --json commits --jq '.commits[]')
        for commit in $pr_commits

            set -l messageHeadline (echo $commit | jq -r .messageHeadline)
            set -l oid (echo $commit | jq -r .oid)
            echo "Checking commit: $oid"
            echo -e "$messageHeadline\n"
            set foundCommit "false"
            for bcommit in $backport_commits
                #echo $bcommit | jq -r .messageHeadline
                #echo $bcommit | jq -r .oid
                set --local message (echo $bcommit | jq -r .messageBody) 
                set --local rebased_from_hash (echo -e (string join "\n" -- $message) | grep 'Rebased-From:' | cut -d ' ' -f 2)
                #echo $rebased_from_hash
                if test -n "$rebased_from_hash"; and test $rebased_from_hash = $oid
                    set foundCommit "true"
                    break
                end
            end
            if test $foundCommit = "true"
                echo -e "✅ Commit $oid found in backport PR\n"
            else
                echo -e "❌ Commit $oid not found in backport PR\n"
            end
            
        end
        #echo $backport_commits
    end

    # Fetch commits from the backport PR

    ## Track missing commits and count
    #set -l missing_commits
    #set -l total_missing 0
    #
    ## Check commits for each source PR
    #for pr in $source_prs
    #    # Fetch commits from the source PR
    #    set -l source_commits (gh pr view $pr --json commits --jq '.commits[].oid')
    #
    #    # Check each source PR commit
    #    for commit in $source_commits
    #        if not contains -- $commit $backport_commits
    #            set -a missing_commits $commit
    #            set total_missing (math $total_missing + 1)
    #        end
    #    end
    #end
    #
    ## Report results
    #if test $total_missing -eq 0
    #    echo "✅ All commits from source PRs are included in the backport PR!"
    #    return 0
    #else
    #    echo "❌ $total_missing commit(s) from source PRs are missing in the backport PR:"
    #    for commit in $missing_commits
    #        echo "   - $commit"
    #    end
    #    return 1
    #end
end
