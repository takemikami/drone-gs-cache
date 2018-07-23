#!/bin/bash

# variable check
if [ -z "$PLUGIN_BUCKET" ]; then
  echo "bucket parameter is required."
  exit 1
fi
if [ -z "$PLUGIN_KEYFILES" ]; then
  if [ "$PLUGIN_RESTORE" == "true" -o "$PLUGIN_SAVE" == "true" ]; then
    echo "keyfiles parameter is required."
    exit 1
  fi
fi
if [ -z "$PLUGIN_PATHS" ]; then
  if [ "$PLUGIN_SAVE" == "true" ]; then
    echo "paths parameter is required."
    exit 1
  fi
fi
if [ -z "$PLUGIN_KEEP_CACHE_AGE" ]; then
  if [ "$PLUGIN_CLEAN" == "true" ]; then
    echo "keep_cache_age parameter is required."
    exit 1
  fi
fi

# common variables
CACHE_PATH_PREFIX=gs://${PLUGIN_BUCKET}/cache/${DRONE_REPO_OWNER}/${DRONE_REPO_NAME}
CACHE_KEY=$(md5sum ${PLUGIN_KEYFILES//,/ } | md5sum | awk '{print $1}')
CACHE_FILE_NAME=${CACHE_PATH_PREFIX}/${CACHE_KEY}.tar.gz

# restore
restore_cache() {
  echo $CACHE_FILE_NAME
  gsutil ls $CACHE_FILE_NAME
  exist=$?
  echo $exist
  if [ $exist -eq 0 ]; then
    mkdir -p .drone/tmp
    gsutil cp ${CACHE_FILE_NAME} .drone/tmp/${CACHE_KEY}.tar.gz
    tar zxf .drone/tmp/${CACHE_KEY}.tar.gz -C ./
    rm -rf .drone/tmp/${CACHE_KEY}.tar.gz
    echo "restore cache from ${CACHE_FILE_NAME}"
  fi
}

# save
save_cache() {
  gsutil ls $CACHE_FILE_NAME
  exist=$?
  if [ $exist -eq 1 ]; then
    mkdir -p .drone/tmp
    tar czf .drone/tmp/${CACHE_KEY}.tar.gz ${CACHE_PATHS//,/ }
    gsutil cp .drone/tmp/${CACHE_KEY}.tar.gz ${CACHE_FILE_NAME}
    echo "save cache to ${CACHE_FILE_NAME}"
  fi
}

# clean
clean_cache() {
  gsutil ls -l $CACHE_PATH_PREFIX \
    | awk '{print $2,$3}' \
    | sort -r \
    | tail -n +$(($PLUGIN_KEEP_CACHE_AGE+1)) \
    | awk '{print $2}' \
    | xargs gsutil rm
}

# main routine
if [ "$PLUGIN_RESTORE" == "true" ]; then
  restore_cache
fi

if [ "$PLUGIN_SAVE" == "true" ]; then
  save_cache
fi

if [ "$PLUGIN_CLEAN" == "true" ]; then
  clean_cache
fi

