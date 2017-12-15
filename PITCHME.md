@title[Introduction]
## Towards Monorepo with <span style="color: #e49436">Gitlab CI</span>

#### TODO
<br>
<br>

---

### <span style="color: #e49436">What is a Monorepo?</span>

- TODO |
- TODO |

---

### <span style="color: #e49436">Why and When?</span>

- TODO |

---

### <span style="color: #e49436">How to use?</span>

- Add `.monorepo.gitlab` as a submodule |
- Update your `gitlab-ci.yml` |

+++

@title[Step 1. Add submodule]

### <span style="color: #e49436">STEP 1. Add submodule</span>
<br>

```console
$ git submodule add https://github.com/awesome-inc/monorepo.gitlab.git .monorepo.gitlab
```

+++?code=.gitlab-ci.yml&lang=yml&title=Step 2. Update your gitlab-ci.yml

@[1-3](Set an API token for GitLab)
@[5](Instruct GitLab CI to clone submodules)
@[6](Specify your GitLab Server url)
@[7-8](Add before script to check for last green commit)
---

### View The <a target="_blank" href="https://github.com/mkoertgen/hello.gitlab.monorepo">Code</a>
