require 'net/http'
require 'json'
require 'time'

JENKINS_URI = "%URLJENKINS%"

JENKINS_AUTH = {
  'name' => '%NAME%',
  'password' => '%PASSWORD%'
}

def get_number_of_failing_tests(job_name)
  info = get_json_for_job(job_name, 'lastCompletedBuild')
  info['actions'][4]['failCount']
end

def get_completion_percentage(job_name)
  build_info = get_json_for_job(job_name)
  prev_build_info = get_json_for_job(job_name, 'lastCompletedBuild')

  return 0 if not build_info["building"]
  last_duration = (prev_build_info["duration"] / 1000).round(2)
  current_duration = (Time.now.to_f - build_info["timestamp"] / 1000).round(2)
  return 99 if current_duration >= last_duration
  ((current_duration * 100) / last_duration).round(0)
end

def get_json_for_job(job_name, build = 'lastBuild')
  job_name = URI.encode(job_name)

  get_json_by_url("#{JENKINS_URI}/job/#{job_name}/#{build}/api/json")
end

def get_json_by_url(url)
  uri = URI(url)

  req = Net::HTTP::Get.new(uri.request_uri)
  req.basic_auth JENKINS_AUTH['name'], JENKINS_AUTH['password']

  res = Net::HTTP.start(uri.hostname, uri.port) {|http|
    http.request(req)
  }
  JSON.parse(res.body)
end

def get_all_jobs()
  get_json_by_url("#{JENKINS_URI}/api/json")['jobs']
end

Jobs = get_all_jobs()
for job in Jobs do
  print("Job: #{job['name']}\n")
  if job['color'] != 'disabled'
    jobDetails = get_json_for_job(job['name'])
    print JSON.pretty_generate(jobDetails)
    print("\nname:#{job['name']}\n\n")
  end
end
