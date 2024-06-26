local build_image = import '../util/build_image.jsonnet';
local pipelines = import '../util/pipelines.jsonnet';

[
  pipelines.linux('Test Linux system packages') {
    trigger: {
      ref: ['refs/heads/main'],
      paths: [
        'packaging/**',
        'internal/tools/packaging_test/**',
        'Makefile',
        'tools/make/*.mk',
      ],
    },
    steps: [{
      name: 'Test Linux system packages',
      image: build_image.linux,
      volumes: [{
        name: 'docker',
        path: '/var/run/docker.sock',
      }],
      commands: [
        'DOCKER_OPTS="" make dist/alloy-linux-amd64',
        'DOCKER_OPTS="" make test-packages',
      ],
    }],
    volumes: [{
      name: 'docker',
      host: {
        path: '/var/run/docker.sock',
      },
    }],
  },
]
