kubectl set env deployment/external-secrets \
 -n external-secrets \
 AWS_ENDPOINT_URL_SECRETS_MANAGER=http://192.168.169.170:4566

kubectl get deployment external-secrets -n external-secrets \
 -o jsonpath='{.spec.template.spec.containers[0].env}' | jq

vagrant@master:~$ aws secretsmanager create-secret --name "prod/db-credentials" \

>      --secret-string '{"username":"local_admin","password":"LocalSecurePassword2026"}' \
>      --endpoint-url=http://localhost:4566 \
>      --region us-east-1

-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEOblF+AkVecNUrKxyw70JfD+Iae+d
kK1idqVxk0IPX1g0+Qqv7UTp17UI2wfOCCZ9QGA4aQOgu/wHVJNZI5uWQg==
-----END PUBLIC KEY-----
