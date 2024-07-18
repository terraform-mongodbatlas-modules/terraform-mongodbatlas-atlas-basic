provider "mongodbatlas" {
}

run "generate_random_name" {
    module {
        source = "./tests/random_name_generator"
    }
}

run "atlas_basic_complete" {
    command = apply

    module {
        source = "./"
    }

    variables {
        project_name = "test-modules-tf-p-${run.generate_random_name.name_project}"
        ip_addresses = ["1.2.3.4", "6.7.8.9"]
        cidr_blocks  = ["10.1.0.0/16", "12.2.0.0/16"]
        cluster_name  = "AzureCluster"
        provider_name = "AZURE"
        region_name   = "US_EAST_2"

        database_users = [
            {
            username = "user1"
            password = "1234"
            roles = [
                {
                    role = "atlasAdmin"
                    database = "admin"
                }
            ]
            scopes = [
                {
                    name = "cluster1"
                    type = "CLUSTER"
                }
            ]
            }, 
            {
                username = "user2", 
                password = "4321", 
                roles = [
                    {
                        role = "atlasAdmin"
                        database = "admin"
                    }
                ]
            }
        ]
        
        electable_specs = {
            instance_size = "M10"
            node_count = 5
        }
        analytics_specs = {
            instance_size = "M10"
            node_count = 3
        }
    }

    assert {
        condition = mongodbatlas_database_user.dbuser["user1"].username == "user1"
        error_message = "Invalid database username"
    }

    assert {
        condition = mongodbatlas_database_user.dbuser["user2"].username == "user2"
        error_message = "Invalid database username"
    }

    assert {
        condition = mongodbatlas_advanced_cluster.cluster.name == "AzureCluster"
        error_message = "Invalid cluster name"
    }
}
