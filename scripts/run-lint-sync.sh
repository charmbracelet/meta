# NOTE(@andreynering): This script runs the `lint-sync.yml` workflow for
# all public repositories.

REPOS=$(gh repo list charmbracelet --visibility public --no-archived --limit 1000 --json "name" -t '{{range .}}{{printf "%s\n" .name}}{{end}}')
REPOS=$(echo "$REPOS" | awk '$0 != "x" && $0 != ".github" && $0 != "meta" && $0 != "homebrew-tap" && $0 != "scoop-bucket"' | sort)

for repo in $REPOS; do
  echo "Dispatching lint-sync.yml for $repo"
  gh workflow run -R charmbracelet/$repo lint-sync.yml
done
