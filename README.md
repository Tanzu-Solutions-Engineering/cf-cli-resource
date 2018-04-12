# Cloud Foundry CLI Concourse Resource

This fork is no longer maintained. Please reference the main repo [nulldriver/cf-cli-resource](https://github.com/nulldriver/cf-cli-resource) and update your Concourse pipelines to use the updated Docker Hub location:

```yml
resource_types:
- name: cf-cli-resource
  type: docker-image
  source:
    repository: nulldriver/cf-cli-resource
    tag: latest
```
