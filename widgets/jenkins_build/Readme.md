## Description

[Dashing](http://shopify.github.com/dashing) widget to display a [Jenkins](http://jenkins-ci.org/) build status and build progress

The widget is based on the meter-widget which is default in the Dashing installation

The widget can also see the progress of a "pre-build", i.e if you have a job triggering the actual build you want to define, you can configure this job in the jenkins_build.rb as a prebuild.

For more information, please see [Coding Like a tosser](http://wp.me/p36836-p)

## Installation

Put the files `jenkins_build.coffee`, `jenkins_build.html` and `jenkins_build.scss` goes in the `/widget/jenkins_build` directory and the `jenkins_build.rb`  in the `/jobs` directory

Otherwise you can install this plugin typing:

    dashing install GIST_ID

## Usage (`jenkins_build.rb`)

Change the `JENKINS_URI` to your correct uri for Jenkins, eg.:

    JENKINS_URI = URI.parse("http://ci.yourserver.com")

Add jenkins credential (if required) in JENKINS_AUTH, eg.:

    JENKINS_AUTH = {
      'name' => 'username',
      'password' => 'password'
    }

Put all the jobnames and pre job names in the `job_mapping`, eg.:

    job_mapping = {
      'job1' => { :job => 'Job Name 1'},
      'job2' => { :job => 'Job Name 2', :pre_job => 'Job Name 3'},
    }

Put the following in your dashingboard.erb file to show the status:

    <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="job1" data-view="JenkinsBuild" data-title="Build title" data-description="A little description of build" data-min="0" data-max="100"></div>
    </li>

Multiple jobs can add in dashboard repeating the snippet and changing ```data-id``` in accord with job name specified in ```job_mapping```. Widget support title and description via data attributes, this attributest can be omitted if you do not like to display this information.
