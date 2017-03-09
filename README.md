Kubernetes experiments
======================

Tutorials, excercises and experiments on K8S.



## Install Deis

Ensure you have helm installed and properly configured:

    helm version

This should show the client and server version. If server version is missing
you should init helm:

    helm init

Now install Deis Workflow

    helm repo add deis https://charts.deis.com/workflow
    helm install deis/workflow --namespace deis

The complete tutorial to install Deis on AWS is [here][1].


[1]: https://deis.com/docs/workflow/quickstart/provider/aws/install-aws/ "Deis Workflow"
