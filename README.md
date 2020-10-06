# CMAK (Cluster Manager for Apache Kafka, previously known as Kafka Manager)
Dockerized version of the [CMAK](https://github.com/yahoo/CMAK) tool with added kerberos auth support

The original Dockerfile was stolen from [vimagick/dockerfiles](https://github.com/vimagick/dockerfiles/tree/master/cmak)

The following improvements were made
- It is now running as user scala
- Kerberos utils are installed
- Includes a script that runs in the background and renews kerberos tickets using kinit 

## Deployment

Can be deployed in plain Docker, docker-compose, swarm(probably) or kubernetes

### General requirements
- a folder containing krb5.conf from the environment must be mounted to /app inside the container
- a set of KINIT_ variables must be defined in the environment to configure Kerberos auth
- a set of variables can be used to preconfigure CMAK

| variable                   | default        | description                                                                             |
| --------                   | -------------- | -------                                                                                 |
| KINIT                      | /usr/bin/kinit | *path to kinit binary*                                                                  |
| KINIT_PRINCIPAL            |                | *kerberos principal to use*                                                            |
| KINIT_KEYTAB               | /app/keytab    | *kerberos keytab to use*                                                                |
| KINIT_LIFETIME             | 10h            | *kerberos ticket lifetime*                                                              |
| KINIT_RENEWABLE_LIFE       | 7d             | *ticket renewable lifetime*                                                             |
| KINIT_RENEWABLE_SLEEP      | 60             | *ticket renew interval (seconds)*                                                       |
| ZK_HOSTS                   |                | *zookeeper hosts to connect to register CMAK instance(not the managed kafka clusters!)* |
| KAFKA_MANAGER_AUTH_ENABLED | false          | *enable cmak build in basic auth*                                                       |
| KAFKA_MANAGER_USERNAME     |                | *password for basic auth*                                                               | 
| KAFKA_MANAGER_PASSWORD     |                | *password for basic auth*                                                               |

### Deployment
#### Docker
Use `docker.sh` script for reference

#### Docker compose
Use `docker-compose.yml` manifest for reference

#### Kubernetes
1. Create a configMap containing krb5.conf file
`kubectl -n <namespace> create configmap krb5 --from-file=./krb5.conf`
2. Mount it as a volume under /app (hardcoded in the dockerfile, can be overriden in `files/init.sh`)
3. Create a secret containing keytab file
`kubectl -n <namespace> create configmap krb5 --from-file=./my-mega.keytab`
4. Mount the secret as the /etc/security/keytabs (or any other path)
5. Configure KINIT_PRINCIPAL, KINIT_KEYTAB, ZK_HOSTS at least using configmaps  secrets, or whatever
6. Configure ingress
