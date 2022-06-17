repo = "spritsail/debian-builder"
archs = ["amd64", "arm64"]
branches = ["master"]
versions = {
  "bullseye-slim": ["latest", "stable"],
  "bookworm-slim": ["testing"],
  "sid-slim": ["unstable"],
}

def main(ctx):
  builds = []

  for ver, tags in versions.items():
    depends_on = []
    for arch in archs:
      key = "build-%s-%s" % (ver, arch)
      builds.append(step(ver, arch, key))
      depends_on.append(key)

    if ctx.build.branch in branches:
      builds.append(publish(ver, depends_on, tags))

  return builds

def step(ver, arch, key):
  tmprepo = "drone/%s/${DRONE_BUILD_NUMBER}:%s-%s" % (repo, ver, arch)
  return {
    "kind": "pipeline",
    "name": key,
    "platform": {
      "os": "linux",
      "arch": arch,
    },
    "steps": [
      {
        "name": "build",
        "image": "spritsail/docker-build",
        "pull": "always",
        "settings": {
          "build_args": [
            "DEBIAN_TAG=%s" % ver,
          ],
          "repo": tmprepo,
        },
      },
      {
        "name": "test",
        "image": "spritsail/docker-test",
        "pull": "always",
        "settings": {
          "run": "for b in tar xz bzip2 gawk gcc; do $b --version; done",
          "repo": tmprepo,
        },
      },
      {
        "name": "publish",
        "image": "spritsail/docker-publish",
        "pull": "always",
        "settings": {
          "from": tmprepo,
          "repo": tmprepo,
          "registry": {"from_secret": "registry_url"},
          "login": {"from_secret": "registry_login"},
        },
        "when": {
          "branch": branches,
          "event": ["push"],
        },
      },
    ]
  }

def publish(ver, depends, tags=[]):
  return {
    "kind": "pipeline",
    "name": "publish-%s" % ver,
    "depends_on": depends,
    "platform": {
      "os": "linux",
    },
    "steps": [
      {
        "name": "publish",
        "image": "spritsail/docker-multiarch-publish",
        "pull": "always",
        "settings": {
          "src_template": "drone/%s/${DRONE_BUILD_NUMBER}:%s-ARCH" % (repo, ver),
          "src_registry": {"from_secret": "registry_url"},
          "src_login": {"from_secret": "registry_login"},
          "dest_repo": repo,
          "dest_login": {"from_secret": "docker_login"},
          "tags": [ver] + tags,
        },
        "when": {
          "branch": branches,
          "event": ["push"],
        },
      },
    ]
  }

# vim: ft=python sw=2
