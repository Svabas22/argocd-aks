helm repo add argo-cd https://argoproj.github.io/argo-helm
kubectl create ns argocd

helm install argo-cd argo-cd/argo-cd -n argocd -f values.yaml

[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String((kubectl get secret grafana -n argocd -o jsonpath="{.data.admin-password}")))

[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String((kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}")))
#the command looks scary due to how decoding Base64 works in PowerShell without extra utilities. Bash example:
#kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode

kubectl patch configmap argocd-cm -n argocd --type merge -p '{"data":{"kustomize.buildOptions":"--enable-helm"}}'

kubectl port-forward service/argo-cd-argocd-server -n argocd 8080:80

cd .\applications\base

kubectl kustomize .

kubectl kustomize . | kubectl apply -f -