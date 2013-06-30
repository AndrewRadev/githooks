require 'spec_helper'
require 'githooks/command/fetch'

module Githooks
  module Command
    describe Fetch do
      describe "(local path)" do
        it "fetches a git hook from a local directory and puts it in its right place" do
          ensure_parent_directory 'hook-source/test-hook/run'
          create_metadata('hook-source/test-hook', 'type' => 'post-merge')
          create_script('hook-source/test-hook', <<-EOF)
            #! /bin/sh
            echo "OK"
          EOF

          Fetch.call('hook-source/test-hook')

          expect_hook_exists 'test-hook'
        end
      end

      describe "(github url)" do
        it "fetches a git hook from github and puts it in its right place" do
          github_root  = 'https://raw.github.com/user/repo/master'
          script_url   = "#{github_root}/path/to/test-hook/run"
          metadata_url = "#{github_root}/path/to/test-hook/meta.yml"

          metadata = test_metadata('description' => 'remote metadata')
          FakeWeb.register_uri(:get, metadata_url, :body => YAML.dump(metadata))
          FakeWeb.register_uri(:get, script_url, :body => <<-EOF)
            #! /bin/sh
            echo "OK"
          EOF

          Fetch.call('github.com/user/repo/path/to/test-hook')

          expect_hook_exists 'test-hook'
        end
      end

      describe "(local script)" do
        it "does nothing for a locally fetched script" do
          create_script(Support.hooks_root.join('test-script'))
          create_metadata(Support.hooks_root.join('test-script'))

          Fetch.call('test-script')
        end
      end
    end
  end
end