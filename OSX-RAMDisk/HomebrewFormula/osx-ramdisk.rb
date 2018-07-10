class OSXRamDisk < Formula
    desc "Create RAM disk for browsers and EDIs"
    homepage "https://zafarella.github.io/OSX-RAMDisk/"
    url "https://github.com/zafarella/OSX-RAMDisk"
    sha256 "8313f353507175731dc0f7de445048fd3877f4859d921bc622af274e089914a3"

    #depends_on "newfs_hfs"

    head do
        url "https://github.com/zafarella/OSX-RAMDisk"
    end

    def install
        # Remove unrecognized options if warned by configure
        system "./configure", "--disable-debug",
            "--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}"
        system "make", "install" # if this fails, try separate make/make install steps
    end

    test do
        system "ls -lsa /Users/${USER}/ramdisk"
        system "false"
    end
end
