[![GitPitch](https://gitpitch.com/assets/badge.svg)](https://gitpitch.com/awesome-inc/hello.gitlab.monorepo/master)

# hello.gitlab.monorepo

A simple script helping towards using [GitLab CI](https://docs.gitlab.com/ee/ci/yaml/) with [Monorepo](https://medium.com/@maoberlehner/monorepos-in-the-wild-33c6eb246cb9).

Mostly adapted from workarounds given in [gitlab-ce/issues/19232](https://gitlab.com/gitlab-org/gitlab-ce/issues/19232).
Hopefully soon to be integrated into GitLab CI!

## How to use

Add as a submodule

```bash
git submodule add https://github.com/awesome-inc/monorepo.gitlab.git .monorepo.gitlab
```

and update your `.gitlab-ci.yml`.

- Add some `variables` and a `before_script` to get the *last green commit* in Gitlab CI:

```yml
# needs `curl`, `jq` 1.5 and `${PRIVATE_TOKEN}, cf.:
# - https://docs.gitlab.com/ee/api/#personal-access-tokens
# - https://docs.gitlab.com/ce/ci/variables/README.html#secret-variables
variables:
  GIT_SUBMODULE_STRATEGY: recursive
  CI_SERVER_URL: https://gitlab.com
before_script:
    - .monorepo.gitlab/last_green_commit.sh
```

- Build you sub-component `foo` only when there are diffs in `./foo` since `${LAST_COMMIT}`

```yml
build-foo:
  script:
    # before
    - cd foo
    - <build foo>
    # after
    - .monorepo.gitlab/build_if_changed.sh foo <build foo>
```