## Dashboard Set up

The following are the minimum requirements <sup>1</sup> for setting up this dashboard using Shiny Server on Ubuntu Amazon Web Services (AWS)<sup>2</sup> (you can also apply this procedure for your localhost).

---

###Create an AWS instance (follow the images for each step).

  - Step 0: Launch a new instance.
  
    <p align="center">
    <img src="https://raw.githubusercontent.com/chpmoreno/ISAMDashboard/master/Dashboard/www/Readme_png/launch_instance_001.png" width="650"/>
    </p>

  - Step 1: Search and select an Ubuntu image (For BGSE image please search in community AMIs ami-0fdd6a7c).
    <p align="center">
    <img src="https://raw.githubusercontent.com/chpmoreno/ISAMDashboard/master/Dashboard/www/Readme_png/launch_instance_002.png" width="650"/>
    </p>
    
  - Step 2: Choose an instance type (there is one free tier).
  
    <p align="center">
    <img src="https://raw.githubusercontent.com/chpmoreno/ISAMDashboard/master/Dashboard/www/Readme_png/launch_instance_003.png" width="650"/>
    </p>
  
  - Step 3: Configure instance details (mantain the default settings).
  
    <p align="center">
    <img src="https://raw.githubusercontent.com/chpmoreno/ISAMDashboard/master/Dashboard/www/Readme_png/launch_instance_004.png" width="650"/>
    </p>
    
  - Step 4: Add Storage (mantain the default settings)
  
    <p align="center">
    <img src="https://raw.githubusercontent.com/chpmoreno/ISAMDashboard/master/Dashboard/www/Readme_png/launch_instance_005.png" width="650"/>
    </p>
    
  - Step 5: Tag instance (p.e. BGSEDSDashboard)
  
    <p align="center">
    <img src="https://raw.githubusercontent.com/chpmoreno/ISAMDashboard/master/Dashboard/www/Readme_png/launch_instance_006.png" width="650"/>
    </p>
  - Step 6: Configure Security Group (follow the picture below. The most importante rule is highlighted due to the fact that it is the default port for shiny server.) and Review and Launch. 
  
    <p align="center">
    <img src="https://raw.githubusercontent.com/chpmoreno/ISAMDashboard/master/Dashboard/www/Readme_png/launch_instance_007.png" width="650"/>
    </p>
    
  - Step 7: They are going to ask for an access key, if you don't have one then create it (http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)

---

###R, R libraries and Shiny Server set up (using the terminal).

**AWS Ubuntu server**

  - Step 0: Update Ubuntu.
  
    ```
    sudo apt-get update
    sudo apt-get upgrade
    ```
  
  - Step 1: Create a swap file.
  
    ```
    sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=1000
    sudo mkswap /var/swap.img
    sudo swapon /var/swap.img
    ```

  - Step 2: Install auxiliar depencencies required.
  
    ```
    sudo apt-get install libgdal-dev libcurl4-openssl-dev libcurl4-gnutls-dev libcairo2-dev libxt-dev librtmp-dev
    ```
    
  - Step 3: Install last version of R (take into account your Ubuntu version).
    
    ```
    sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list
    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
    gpg -a --export E084DAB9 | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install r-base r-base-dev
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
  - Step 6: Clone Github Repository (be sure git is installed on the image).
    
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

**BGSE Ubuntu Image Version (in community AMIs search ami-0fdd6a7c)**.
  
  - Step 0: Update Ubuntu and uninstall R.
  
    ```
    sudo apt-get autoremove
    sudo apt-get remove r-base* r-cran*
    sudo apt-get update
    sudo apt-get upgrade
    ```
  
  - Step 1: Create a swap file.
  
    ```
    sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=1000
    sudo mkswap /var/swap.img
    sudo swapon /var/swap.img
    ```

  - Step 2: Install auxiliar depencencies required.
  
    ```
    sudo apt-get install libgdal-dev
    sudo apt-get install libcurl4-gnutls-dev
    sudo apt-get install libcairo2-dev
    ```
    
  - Step 3: Install last version of R (take into account your Ubuntu version).
    
    ```
    sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" | sudo tee -a /etc/apt/sources.list
    gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
    gpg -a --export E084DAB9 | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install r-base r-base-dev
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
  - Step 6: Clone Github Repository (be sure git is installed on the image).
    
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
### Links.

- http://shiny.rstudio.com/
- http://rstudio.github.io/shinydashboard/index.html
- https://www.rstudio.com/resources/webinars/shiny-developer-conference/
- http://deanattali.com/
- http://deanattali.com/blog/advanced-shiny-tips/
- http://stackoverflow.com/tags/shiny/topusers
- https://www.r-bloggers.com/deploying-your-very-own-shiny-server/
- http://stackoverflow.com/questions/28794261/rstudio-shiny-error-there-is-no-package-called-shinydashboard/32996405#32996405
- http://rstudio.github.io/shiny-server/os/latest/
- https://support.rstudio.com/hc/en-us/sections/203091177-Shiny-Server
- http://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/
- https://www.r-bloggers.com/deploying-your-very-own-shiny-server/
- https://www.digitalocean.com/community/tutorials/how-to-set-up-shiny-server-on-ubuntu-14-04
- https://www.rstudio.com/products/shiny/shiny-server/
- https://www.r-bloggers.com/installing-rstudio-shiny-server-on-aws/
- https://www.r-bloggers.com/deploying-shiny-server-on-amazon-some-troubleshoots-and-solutions/

  ---
*Footnotes*

<sub> 
  <sup>1</sup> If you want to run the shiny app on your local computer, you need to install RStudio and the required packages (install.packages(c('shiny', 'shinydashboard', 'lubridate', 'Cairo', 'dplyr', 'ggplot2', 'readr', 'scales', 'wordcloud', 'stringi', 'DT', 'plotly', 'tagcloud', 'feather', 'rmarkdown'))). 
  <sup>2</sup> You should have signed up on AWS (https://aws.amazon.com/free/ or https://portal.aws.amazon.com/gp/aws/developer/registration/index.html).
<sub>