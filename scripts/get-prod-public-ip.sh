PUBLIC_IP=$(k get svc azure-vote-front -n azure-vote -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl http://$PUBLIC_IP