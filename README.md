This repository consist of 2 main parts (file):
- Dockerfile
- nrp.yml

The `Dockerfile` defines the modification applied to the base image of NRP backend from `hbpneurorobotics/nrp:dev` tuned for deployment on Kubernetes cluster inside Google Cloud Platform environment.

Any commit to the `master` branch will automatically trigger a build to the respected [Docker Hub](https://hub.docker.com/repository/docker/rifqifatih/nrp) repository.

Pull the image from repository:
```
docker pull rifqifatih/nrp:latest
```

The `nrp.yml` defines the Service and Deployment Kubernetes configuration. To apply this in your Kubernetes cluster run
```
kubectl apply -f nrp.yml
```