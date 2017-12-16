@title[Introduction]
## Towards Monorepo with <span style="color: #e49436">Gitlab CI</span>

#### Conditional builds with GitLab CI using docker-compose by example
<br>
<br>

---

### <span style="color: #e49436">What is a Monorepo?</span>

Google knows. The top 5 results when googling for "monorepo"

- [Advantages of monolithic version control - Dan Luu](https://danluu.com/monorepo/) |
- [Monorepos in the Wild](https://medium.com/@maoberlehner/monorepos-in-the-wild-33c6eb246cb9) |
- [Why is Babel a monorepo?](https://github.com/babel/babel/blob/master/doc/design/monorepo.md) |
- [korfuri/awesome-monorepo](https://github.com/korfuri/awesome-monorepo) |
- [Monorepos in Git - Atlassian](https://developer.atlassian.com/blog/2015/10/monorepos-in-git/) |

---

### <span style="color: #e49436">Seriously. What is a Monorepo?</span>

> Definitions vary but speaking very broadly, 
> a Monorepo is a single repository holding the code of multiple projects 
> which may or may not be related in some way.

---

### <span style="color: #e49436">Why and When?</span>

- TODO |

---

### <span style="color: #e49436">What you get here?</span>

- Right now, GitLab CI is not really built for monorepos (cf.: [gitlab-ce/issues/19813](https://gitlab.com/gitlab-org/gitlab-ce/issues/19813)) |
- Building all projects on each push not feasible |
- We need to know what changed, in order know what project to build |
- git diff to the rescue! |

---

### <span style="color: #e49436">How to use this repo?</span>

- Add .monorepo.gitlab as a submodule |
- Update your gitlab-ci.yml |

+++

@title[Step 1. Add submodule]

### <span style="color: #e49436">STEP 1. Add submodule</span>
<br>

```console
$ git submodule add \
    https://github.com/awesome-inc/monorepo.gitlab.git \
    .monorepo.gitlab
```

+++?code=.gitlab-ci.yml&lang=yml&title=Step 2. Update your gitlab-ci.yml

@[1-3](Install tools and set an API token for GitLab)
@[5](Instruct GitLab CI to clone submodules)
@[6](Specify your GitLab Server url)
@[7-8](Add before script to check for last green commit)

---

### <span style="color: #e49436">Example using docker-compose</span>

Your [docker-compose.yml](https://docs.docker.com/compose/) may look something like this

```yml
version: '3'
services:
  webapp:
    image: "${DOCKER_REGISTRY}/${REPO}/${PRODUCT}_webapp:${TAG}"
    build:
      context: ./webapp
  ...
```

@[3](The service to build)
@[4](Tag for built docker image)
@[5-6](Docker build context. By convention service name matches directory)

---

Build service using `build.sh`

```bash
#!/bin/bash -ex
component=$1
docker-compose build ${component}
if [ "$CI_BUILD_REF_NAME" -ne "master" ]; then exit; fi
docker-compose push ${component}
```

@[3](Build the specified service/component)
@[4-5](On `master` push built image to Docker registry)

---

*Pro Tip:* Use [YAML anchors](http://blog.daemonl.com/2016/02/yaml.html#yaml-anchors-references-extend) to keep your jobs DRY.

```yml
# Use yml anchors, to keep jobs DRY, cf.: https://docs.gitlab.com/ee/ci/yaml/#anchors
.build_template: &build_definition
  tags:
    - linux
    - docker
  stage: build
  script: .monorepo.gitlab/build_if_changed.sh ${CI_JOB_NAME} \
            ./build.sh ${CI_JOB_NAME}

webapp:
  <<: *build_definition
```

@[2-7](The job template)
@[3-5](All jobs use the same *tags*...)
@[6](And the same *stage*...)
@[7-8](And the same *script*. Note that we use *CI_JOB_NAME*!)
@[10-11](One job is specified by just its name and the template. Great!)

- That's it! |

---

### View The <a target="_blank" href="https://github.com/mkoertgen/hello.gitlab.monorepo">Code</a>
