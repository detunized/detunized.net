require 'yaml'

module Jekyll
    class SymbolicLink < StaticFile
        def write dest
            # Delete symlink first. Otherwise it creates a link inside a linked directory.
            dst_path = destination(dest)
            FileUtils.rm dst_path if File.exists? dst_path
            FileUtils.ln_s path, dst_path
        end
    end

    class LinkGalleries < Generator
        safe true

        def generate site
            site.static_files << SymbolicLink.new(site, site.source, '', 'galleries')
        end
    end
end
