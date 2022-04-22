# Create a ContainerRegistryClient that will authenticate through Active Directory
from azure.containerregistry import ContainerRegistryClient
from azure.identity import DefaultAzureCredential

endpoint = "https://sandeshyapuramcr.azurecr.io"
audience = "https://management.azure.com"
client = ContainerRegistryClient(endpoint, DefaultAzureCredential(), audience=audience)


from azure.containerregistry import ArtifactTagOrder
with ContainerRegistryClient(endpoint, DefaultAzureCredential(), audience="https://management.azure.com") as client:
    print(f"found {client.list_repository_names()} repositories")
    for repository in client.list_repository_names():
        print(f"repository name is {repository}")
        tag_count = 0
        for tag in client.list_tag_properties(repository, order_by=ArtifactTagOrder.LAST_UPDATED_ON_DESCENDING):
            print(f"found tag {tag}")
            tag_count += 1
            if tag_count > 5:
                print("Deleting {}:{}".format(repository, tag.name))
                client.delete_tag(repository, tag.name)