def main(ctx):
  return [
    step("buster-slim",["latest"]),
    step("bullseye-slim"),
    step("sid-slim"),
  ]

def step(tag,tags=[]):
  debian = tag.split('-', 2)[0]
  return {
    "kind": "pipeline",
    "name": "build-%s" % debian,
    "steps": [
      {
        "name": "build",
        "image": "spritsail/docker-build",
        "pull": "always",
        "settings": {
          "repo": "debian-builder-%s" % debian,
          "build_args": [
            "DEBIAN_TAG=%s" % tag,
          ],
        },
      },
      {
        "name": "test",
        "image": "spritsail/docker-test",
        "pull": "always",
        "settings": {
          "repo": "debian-builder-%s" % debian,
          "run": "for b in tar xz bzip2 gawk gcc; do $b --version; done",
        },
      },
      {
        "name": "publish",
        "image": "spritsail/docker-publish",
        "pull": "always",
        "settings": {
          "from": "debian-builder-%s" % debian,
          "repo": "spritsail/debian-builder",
          "tags": [tag] + tags,
        },
        "environment": {
          "DOCKER_USERNAME": {
            "from_secret": "docker_username",
          },
          "DOCKER_PASSWORD": {
            "from_secret": "docker_password",
          },
        },
        "when": {
          "branch": ["master"],
          "event": ["push"],
        },
      },
    ]
  }

