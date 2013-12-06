include_recipe 'deis::docker'

# checkout the slugbuilder project
git node.deis.build.builder_dir do
  user node.deis.username
  group node.deis.group
  repository node.deis.build.repository
  revision node.deis.build.revision
  action :sync
end

# create a directory to host slugs
directory node.deis.build.slug_dir do
  user node.deis.username
  group node.deis.group
  mode 0777 # nginx needs write access
end

bash 'create-slugbuilder-image' do
  cwd node.deis.build.builder_dir
  code 'docker build -t deis/slugbuilder .'
  not_if 'docker images | grep deis/slugbuilder'
end

template '/usr/local/bin/deis-slugbuilder-hook' do
  source 'slugbuilder-hook.erb'
  mode 0755
  variables({
    :slug_dir => node.deis.build.slug_dir,
    :controller_dir => node.deis.controller.dir,
  })
end

