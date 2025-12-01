---

<details>
<summary>Verifying the artifacts</summary>

First, download the [`checksums.txt` file](https://github.com/charmbracelet/{{.ProjectName}}/releases/download/{{.Tag}}/checksums.txt) and the [`checksums.txt.sigstore.json` file](https://github.com/charmbracelet/{{.ProjectName}}/releases/download/{{.Tag}}/checksums.txt.sigstore.json) files, for example, with `wget`:

```bash
wget 'https://github.com/charmbracelet/{{.ProjectName}}/releases/download/{{.Tag}}/checksums.txt'
wget 'https://github.com/charmbracelet/{{.ProjectName}}/releases/download/{{.Tag}}/checksums.txt.sigstore.json'
```

Then, verify it using [`cosign`](https://github.com/sigstore/cosign):

```bash
cosign verify-blob \
  --certificate-identity 'https://github.com/charmbracelet/meta/.github/workflows/goreleaser.yml@refs/heads/main' \
  --certificate-oidc-issuer 'https://token.actions.githubusercontent.com' \
  --bundle 'checksums.txt.sigstore.json' \
  ./checksums.txt
```

If the output is `Verified OK`, you can safely use it to verify the checksums of other artifacts you downloaded from the release using `sha256sum`:

```bash
sha256sum --ignore-missing -c checksums.txt
```

Done! You artifacts are now verified!

</details>

<a href="https://charm.land/"><img alt="The Charm logo" src="https://stuff.charm.sh/charm-banner-next.jpg" width="400"></a>

Thoughts? Questions? We love hearing from you. Feel free to reach out on [X](https://x.com/charmcli), [Discord](https://charm.land/discord), [Slack](https://charm.land/slack), [The Fediverse](https://mastodon.social/@charmcli), [Bluesky](https://bsky.app/profile/charm.land).
