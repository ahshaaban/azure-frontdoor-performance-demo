📌 Project Overview

This project is a Proof of Concept (PoC) that demonstrates how Azure Front Door improves application performance, reliability, and global availability when integrated with an Azure Storage Account hosting static content.

The project simulates a real-world client scenario where users access content via Azure Front Door instead of directly hitting a storage endpoint. This enables global caching, reduced latency, and enterprise-grade security.

🎯 Objectives

Upload a test file to an Azure Storage Account container.

Provision an Azure Front Door (Standard/Premium) profile with the Storage Account as the origin.

Validate that users can access the file securely through the Front Door endpoint.

Demonstrate performance benefits (latency reduction, caching, global edge presence).

🏗️ Architecture Diagram

Flow Explanation:

Client requests file from https://ahmedshaaban-bzc5a2cqgtdse0cr.b01.azurefd.net/index.html

Azure Front Door receives the request at the edge location closest to the user.

If cached, the file is returned immediately (low latency).

If not cached, Front Door fetches it from Azure Storage (origin).

Response is cached at the edge for subsequent requests.

🚀 Deployment Steps

Go into infra/terraform/

terraform init
terraform apply -auto-approve


Upload your website files:

az storage blob upload-batch \
  --account-name ahmedshaaban \
  --destination '$web' \
  --source ../../site

