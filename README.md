### Highly scalable & highly available infrastructure on AWS. Can be readily used for a three tier application and for two tier with slight modifications

<img width="413" alt="Screenshot 2023-05-17 at 11 19 28" src="https://github.com/nithya-pk/NF_Capstone_Project/assets/105173126/f9f8e817-9b95-40de-a21d-4c123f472dce">

The infrastructure, as shown in the diagram, utilises several AWS components - load balancer, autoscaling frontend and backend servers, Aurora cluster (code is included for both MySQL and PostgreSQL) across availabbilty zones to provide high availablity, efficient performance and easy maintainability. Code is in Terraform.

   * Load balancer ensures that traffic is properly spread across front ends depending on the load. LB can be used for backend too, depending on application needs. "alb_fe.tf" code can be copied, tuned and LB can be setup in a few minutes.
   * EC2 instances - both frontend and backend - are autoscaling groups. This means that they can be scaled up or down depending on loads. CPU utilisation policy (scale up and scale down) is included in the code.
   * Aurora cluster has two instances - one in each availabilty zone - to ensure high availabilty.
   * Code has been written efficiently. Variables have been used wherever necessary so that updates / modifications cab be carried out in one file.

----------------------

#### Cost Estimation

This is only an **estimate**, to give an indication of the costs involved. Actual costs would depend on usage and application needs.

EC2 Instances (FE and BE): Monthly Cost 6.51 USD Upfront Cost 494.06 USD
<br>
Tenancy (Shared Instances), Operating system (Linux), Workload (Weekly, Baseline: 4, Peak: 6, Duration of peak: 3 Days), Advance EC2 instance (t3.micro), Pricing strategy (Compute Savings Plans 3 Year All upfront)

Application Load Balancer: Monthly Cost 16.62 USD

Aurora MySQL Cluster: Monthly Cost 81.76 USD
<br>Y
Change records per statement (0.38), Instance Type (db.t3.medium), Nodes (1), Utilization (100 %Utilized/Month), Instance Family (General purpose)

Total: 104.89 USD Monthly, without including Upfront costs

----------------------


