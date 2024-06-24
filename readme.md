## Steps 

1. add the providers in provider.tf

2. define the relevant variables in variables.tf

3. add the in necessary nginx.conf.tftpl.

4. define the required resources in resources.tf

5. execute terraform init to initialize and download the necessary providers specified in provider.tf.

6. ensure your have the necessary DO_TOKEN defined as global environment variable.
```
export DO_TOKEN=<DO TOKEN>
```

7. Perform a terraform plan.
```
terraform plan -var "do_token=${DO_TOKEN}" -var "ssh_private_key=/root/.ssh/id_rsa" -var "docker_host=<docker host ip>" -var "docker_cert_path=/root/.docker/machine/machines/docker-nginx"
```

8. Once the provision plan is done without error, apply and provision the infrastructure.
```
terraform apply -auto-approve -var "do_token=${DO_TOKEN}" -var "ssh_private_key=/root/.ssh/id_rsa" -var "docker_host=<docker host ip>" -var "docker_cert_path=/root/.docker/machine/machines/docker-nginx"
```

9. To verifiy, go to browser and access the provision nginx address as follows:
```
http://<nginx_ip>:80/
```

10. If you manage to see the boardgame app and perform the necessary CRUD operations, you have successfully completed workshop 01.

11. To tear down the environment, perform the following destroy operation.
```
terraform destroy -var "do_token=${DO_TOKEN}" -var "ssh_private_key=/root/.ssh/id_rsa" -var "docker_host=<docker host ip>" -var "docker_cert_path=/root/.docker/machine/machines/docker-nginx"
```