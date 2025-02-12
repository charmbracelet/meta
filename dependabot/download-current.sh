# NOTE(@andreynering): This is just a script to download dependabot.yml from
# many of our repos. I used it to compare the contents to see which of them
# were different from the base template.

REPOS=$(gh repo list charmbracelet --visibility public --no-archived --limit 1000 --json "name,defaultBranchRef" -t '{{range .}}{{printf "%s %s\n" .name .defaultBranchRef.name}}{{end}}')

rm -rf dependabot/current
mkdir -p dependabot/current

while read -r repo branch; do
  echo "Downloading $repo | $branch"
  curl -s https://raw.githubusercontent.com/charmbracelet/${repo}/refs/heads/${branch}/.github/dependabot.yml > dependabot/current/${repo}.yml
done <<< "$REPOS"
