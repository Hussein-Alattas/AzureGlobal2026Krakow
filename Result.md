# Azure CI/CD project report: passwordless GitHub Actions to Azure

September 2026

## Project summary

I built a passwordless CI/CD pipeline that deploys a containerised web app and its infrastructure to Azure on every push to `main`. It uses GitHub Actions, Terraform modules with remote state, Docker, and OIDC federation with a managed identity. I built it at the Global Azure 2026 Kraków workshop (April 2026). Repository: [Hussein-Alattas/AzureGlobal2026Krakow](https://github.com/Hussein-Alattas/AzureGlobal2026Krakow)

## What was built

GitHub Actions signs in to Azure as a managed identity over OIDC. It then pushes the image to ACR, applies Terraform and updates the App Service. The running app uses Key Vault, SQL and Application Insights.

![.NET Core application on Azure: App Service Plan, App Service, Container Registry, Storage Account, Key Vault, Azure SQL and Application Insights](azure-architecture.png)

## Work completed

1. Created a managed identity with a federated credential for my repo's `main` branch. I gave it the Contributor, AcrPush and Storage Blob Data Contributor roles.
2. Created a storage account for Terraform state and a container registry. I added the identity IDs and the registry server as GitHub secrets.
3. Wrote a three-job GitHub Actions workflow. It builds and pushes the image, runs Terraform init, plan and apply, then updates the App Service.
4. Deployed App Service (B1), Key Vault, Azure SQL and Application Insights with Terraform modules. Secrets live in Key Vault, and Terraform sets the app's environment variables.

## Security design

- No stored passwords: the pipeline uses short-lived OIDC tokens only.
- Least-privilege Azure RBAC, with one role per task.
- App secrets sit in Key Vault, and the app reads them through its managed identity.

## Resume entry

**Passwordless CI/CD Pipeline on Azure** · GitHub Actions, Terraform, Docker, Azure · Global Azure 2026 Kraków workshop, Apr 2026

- Built an end-to-end CI/CD pipeline in GitHub Actions that builds a Docker image, provisions Azure infrastructure with Terraform and deploys the app on every push to `main`.
- Removed all stored cloud credentials by using OIDC workload identity federation between GitHub and a user-assigned managed identity in Microsoft Entra ID.
- Provisioned App Service, Azure SQL, Key Vault, Application Insights and Container Registry with reusable Terraform modules and remote state in Azure Blob Storage.
- Applied least-privilege Azure RBAC (Contributor, AcrPush, Storage Blob Data Contributor) and moved app secrets into Key Vault, read by the app's managed identity.

**One-line version** (for a short projects list): Automated, passwordless Azure deployment pipeline using GitHub Actions, OIDC federation, Terraform modules and Docker, covering App Service, SQL, Key Vault and App Insights.
