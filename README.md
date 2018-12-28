# hello.gitlab.monorepo

[![Build status](https://gitlab.com/mkoertgen/hello.gitlab.monorepo/badges/master/build.svg)](https://gitlab.com/mkoertgen/hello.gitlab.monorepo)
[![GitPitch](https://gitpitch.com/assets/badge.svg)](https://gitpitch.com/awesome-inc/hello.gitlab.monorepo/master)

A simple script helping towards using [GitLab CI](https://docs.gitlab.com/ee/ci/yaml/) with [Monorepo](https://medium.com/@maoberlehner/monorepos-in-the-wild-33c6eb246cb9).

Mostly adapted from workarounds given in [gitlab-ce/issues/19232](https://gitlab.com/gitlab-org/gitlab-ce/issues/19232).
Hopefully soon to be integrated into GitLab CI!

## How to use

Add as a submodule

```bash
git submodule add https://github.com/awesome-inc/monorepo.gitlab.git .monorepo.gitlab
```

and update your `.gitlab-ci.yml`.

- Add some `variables` and a `before_script` to get the *last green commit* in Gitlab CI

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

- Build your sub-component `foo` only when there are diffs in `./foo` since the *last green commit*

```yml
build-foo:
  script:
    # before
    - cd foo
    - <build foo>
    # after
    - .monorepo.gitlab/build_if_changed.sh foo <build foo>
```

## Tips

### DRY Jobs conventions/blueprints

Use [YAML anchors](http://blog.daemonl.com/2016/02/yaml.html#yaml-anchors-references-extend) to keep your jobs DRY, i.e.

```yml
# Use yml anchors, to keep jobs DRY, cf.: https://docs.gitlab.com/ee/ci/yaml/#anchors
.build_template: &build_definition
  tags:
    - linux
    - docker
  stage: build
  script: .monorepo.gitlab/build_if_changed.sh ${CI_JOB_NAME} ./build.sh ${CI_JOB_NAME}

webapp:
  <<: *build_definition
```

### Docker-in-Docker executor

With [awesomeinc/docker.gitlab.monorepo](https://hub.docker.com/r/awesomeinc/docker.gitlab.monorepo) it is easy to use GitLab's [docker-in-docker executor](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html#use-docker-in-docker-executor). Just add this to your `.gitlab-ci.yml`

```yml
variables:
  # cf.: https://docs.gitlab.com/ee/ci/docker/using_docker_build.html
  DOCKER_HOST: tcp://docker:2375/
  DOCKER_DRIVER: overlay2
services:
  - docker:dind
image:
  name: awesomeinc/docker.gitlab.monorepo:0.1.0
  entrypoint: [""] # force an empty entrypoint, cf.: https://gitlab.com/gitlab-org/gitlab-runner/issues/2692#workaround  
```

and you are good to go.