require "rubygems"
require "gem_watch/check"

# Implements a simple check to assure that installed gem(s) are up to date.
class GemWatch::Check::Update < GemWatch::Check
  
  # Check if specified gem(s) are up to date.
  def run
    if gem_name.to_s == 'all'
      Gem::SourceIndex.from_installed_gems.outdated.each {|g| run_on g}
    else
      run_on gem_name
    end
  end
  
  # Displays a formated result with gem name, local and remote version.
  def results
    @impacts.collect do |name, (local_version, remote_version)|
      "%-20s%-10s%s" % [name, local_version, remote_version]
    end
  end

  private
  def run_on(gem_name)
    local = Gem::SourceIndex.from_installed_gems.find_name(gem_name).last

    dep = Gem::Dependency.new local.name, ">= #{local.version}"
    remotes = Gem::SpecFetcher.fetcher.fetch dep
    remote = remotes.last.first
    
    @impacts[local.name] = [local.version, remote.version] if local.version != remote.version
  end
  
end