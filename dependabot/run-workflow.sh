# NOTE(@andreynering): This script runs the `dependabot-sync.yml` workflow for
# all public repositories.

REPOS=$(gh repo list charmbracelet --visibility public --no-archived --limit 1000 --json "name" -t '{{range .}}{{printf "%s\n" .name}}{{end}}')
REPOS=$(echo "$REPOS" | awk '$0 != "x" && $0 != ".github" && $0 != "meta" && $0 != "homebrew-tap" && $0 != "scoop-bucket"' | sort)

for repo in $REPOS; do
  echo "Dispatching dependabot-sync.yml for $repo"
  gh workflow run dependabot-sync.yml -f "repo_name=$repo"
done
