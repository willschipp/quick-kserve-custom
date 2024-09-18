
### command to run model in a docker container
`podman run -e MODEL=/var/model/<model-path> -v <model-root-path>:/var/model -t <image-name>`