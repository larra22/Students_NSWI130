workspace {

    model {

        enterprise {

            studentPerson = person "Student"

            schoolSystem = softwareSystem "University System" {
                subjectContainer = container "Student App" "Presentation of available subjects" "React" "Browser,Microsoft Azure - Static Apps,Azure"
                dbContainer = container "Subjects + Report" "Subjects" "SQL Server" "Database,Microsoft Azure - Azure SQL,Azure"
                dbContainer2 = container "Enrollment + Student" "Enrollment, Student" "SQL Server" "Database,Microsoft Azure - Azure SQL,Azure"
                apiContainer = container "API" "Backend" "ASP.NET Core" "Microsoft Azure - App Services,Azure" {
                group "Web Layer" {
                    controllerComp = component "API Controller" "Requests, responses, routing and serialisation" "ASP.NET Core"
                }
                
                group "Application Layer" {
                    subjectProvider = component "Subject Provider" "Business logic for showing subjects and filter them  by a characteristic if want" "Request handler"
                    enrollmentHandler = component "Enrollment Handler" "Business logic for saving or deleting new enrolls" "Request handler"
                    reportProvider = component "Report Handler" "Business for report creation and validation prior to persistant" "Fluent Validation"
                }
                
                group "Infrastructure Layer" {
                    dbContextComp = component "DB Context" "ORM - Maps linq queries to the data store" "Entity Framework Core"
                }
                group "Domain Layer" {
                    reportDomain = component "Report" "Domain model" "Structure specification"
                    subjectDomain = component "Subject" "Domain model" "Structure specification"
                    enrollDomain = component "Enroll" "Domain model" "Structure specification"
                }
                }
            }
        }

        emailSystem = softwareSystem "Email System" "Sendgrid" "External"

        # relationships between people and software systems
        studentPerson -> subjectContainer "Select subject" "https"
        
        apiContainer -> emailSystem "Trigger emails" "https"
        emailSystem -> studentPerson "Delivers emails" "https"

        # relationships to/from containers
        subjectContainer -> apiContainer "uses" "https"
        apiContainer -> dbContainer "persists data" "https"

        # relationships to/from components
        dbContextComp -> dbContainer "stores (or deletes) and retrieves data"
        dbContextComp -> dbContainer2 "stores and retrieves data"
        subjectContainer -> controllerComp "calls"
        controllerComp ->  reportProvider "sends query to"
        controllerComp ->  subjectProvider "sends query to"
        controllerComp ->  enrollmentHandler "sends query to"
        reportProvider -> dbContextComp "Update data in"
        subjectProvider -> dbContextComp "Gets data from"
        enrollmentHandler -> dbContextComp "Update data in"
        dbContextComp -> reportDomain "contains collections of
        dbContextComp -> subjectDomain "contains collections of"
        dbContextComp -> enrollDomain "contains collections of"
    }

    views {

        systemContext schoolSystem "Context" {
            include * emailSystem
            autoLayout
        }

        container schoolSystem "Container" {
            include *
            #autoLayout
        }

        component apiContainer "Compoent" {
            include * studentPerson
            autoLayout
        }

        themes default "https://static.structurizr.com/themes/microsoft-azure-2021.01.26/theme.json"

        styles {
            # default overrides
            element "Azure" {
                color #ffffff
                #stroke #438dd5
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Database" {
                shape Cylinder
            }
            element "Browser" {
                shape WebBrowser
            }
        }
    }
}
