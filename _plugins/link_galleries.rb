require 'yaml'

module Jekyll
    class SymbolicLink < StaticFile
        def write dest
            FileUtils.ln_s path, destination(dest)
        end
    end

    class LinkGalleries < Generator
        safe true

        def generate site
            site.static_files << SymbolicLink.new(site, site.source, '', 'galleries')
        end
    end
end
