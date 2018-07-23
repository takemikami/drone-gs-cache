drone-gs-cache
---

Caches build artifacts to Google Cloud Storage

## Usage

```
pipeline:
  restore-cache:
    image: takemikami/drone-gs-cache
    restore: true
    keyfiles: package.json
    bucket: bucket-xxx

  *** integration & deployment ****

  save-cache:
    image: takemikami/drone-gs-cache
    save: true
    keyfiles: package.json
    paths:
      - node_modules
    bucket: bucket-xxx

  save-cache:
    image: takemikami/drone-gs-cache
    clean: true
    keep_cache_age: 5
    bucket: bucket-xxx
```

## Build

Build the Docker image with the following commands:

```
docker build --rm -t plugins/gs-cache .
```

Execute from the working directory:

```
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_KEYFILES="package.json" \
  -e PLUGIN_BUCKET="bucket-xxx" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  plugins/gs-cache

docker run --rm \
  -e PLUGIN_SAVE=true \
  -e PLUGIN_KEYFILES="package.json" \
  -e PLUGIN_PATHS="node_modules" \
  -e PLUGIN_BUCKET="bucket-xxx" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  plugins/gs-cache

docker run --rm \
  -e PLUGIN_CLEAN=true \
  -e PLUGIN_KEEP_CACHE_AGE=14 \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  plugins/gs-cache
```

## Works Cited

- https://github.com/drone-plugins/drone-s3-cache
- http://plugins.drone.io/drone-plugins/drone-s3-cache/
- http://readme.drone.io/plugins/plugin-parameters/
