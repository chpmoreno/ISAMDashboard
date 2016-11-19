## Dashboard Set up

The following are the minimum requirements^1^ for setting up this dashboard using Shiny Server on Ubuntu Amazon Web Services (AWS)^2^ (you can also apply this procedure for your localhost).

*Create an AWS instance (follow the images for each step)*.

  - Step 0: Launch a new instance.
  - Step 1: Search and select an Ubuntu image.
  - Step 2: Choose an instance type (there is one free tier).
  - Step 3: Configure instance details (mantain the default settings).
  - Step 4: Add Storage (mantain the default settings)
  - Step 5: Tag instance (p.e. BGSEDSDashboard)
  - Step 6: Configure Security Group (follow the picture below. The most importante rule is highlighted due to the fact that it is the default port for shiny server.) and Review and Launch. 
  - Step 7: They are going to ask for an access key, if you don't have one then create it (http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)

*Configuration of Ubuntu Instance and Shiny Server (using the terminal)*.
  
  - Step 0: Update Ubuntu.
  
    ```
    sudo apt-get update
    sudo apt-get upgrade
    ```
  
  - Step 1: Create a swap file.
  
    ```
    dd if=/dev/zero of=/var/swap.img bs=1024k count=1000
    sudo mkswap /var/swap.img
    sudo swapon /var/swap.img
    ```
  - Step 2: Install last version of R (take into account your Ubuntu version).
    
    ```
    sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list
    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
    gpg -a --export E084DAB9 | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install r-base r-base-dev
    ```
  - Step 3: Install auxiliar depencencies required.
  
    ```
    sudo apt-get install libgdal-dev libcurl4-openssl-dev libcurl4-gnutls-dev libcairo2-dev libxt-dev librtmp-dev
    ```
    
  - Step 4: Install R-packages (for all users).
  
    ```
    sudo su - \-c "R -e \"install.packages(c('shiny', 'shinydashboard', 'lubridate', 'Cairo', 'dplyr', 'ggplot2', 'readr', 'scales', 'wordcloud', 'stringi', 'DT', 'plotly', 'tagcloud', 'feather', 'rmarkdown'), repos='https://cran.rstudio.com/')\""

    ```
  - Step 5: Install Shiny Server (take into account your Ubuntu version).
  
    ```
    sudo apt-get install gdebi-core
    wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.1.834-amd64.deb
    sudo gdebi shiny-server-1.5.1.834-amd64.deb
    ```
  - Step 6: Clone Github Repository.
    
    ```
    cd /srv/shiny-server/
    sudo git clone https://github.com/chpmoreno/ISAMDashboard.git
    ```
  - Step 7: Run the shell script for downloading the data required.
  
    ```
    cd ISAMDashboard/Dashboard/data/
    sudo bash download_data.sh
    ```
    
  - Step 8: Open your app in your prefered browser (you should have launched AWS instance.)
  
    ```
    http://awsipaddress:3838/ISAMDashboard/Dashboard/ or http://localhost:3838/ISAMDashboard/Dashboard/
    ```
    
  ---
*Footnotes*

<sub> 
  <sup>1</sup> If you want to run the shiny app on your local computer, you need to install RStudio and the required packages (install.packages(c('shiny', 'shinydashboard', 'lubridate', 'Cairo', 'dplyr', 'ggplot2', 'readr', 'scales', 'wordcloud', 'stringi', 'DT', 'plotly', 'tagcloud', 'feather', 'rmarkdown'))). 
  <sup>2</sup> You should have signed up on AWS (https://aws.amazon.com/free/ or https://portal.aws.amazon.com/gp/aws/developer/registration/index.html).
<sub>