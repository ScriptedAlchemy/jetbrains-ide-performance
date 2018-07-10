# jetbrains-ide-performance
High Performance Configuration for Jetbrains IDEs [IntelliJ, WebStorm, etc..]

# Motivation

Once you step into the realm of multi-project development, large scale dev, or just have to have like 6 IDE's open. You really start to feel a performance hit on jetbrains IDEs. 

This configuration aims to give at least 10x performance increases across the board. 

# Goals
* Faster Indexing Times
* More Responsive IntelliSense
* Less random freezing or UI lockups
* Better Memory Management
* More multi-threading
* Quicker startup time

# What you need to do

The recommended way of changing the JVM options in the recent product versions is from the **Help | Edit Custom VM Options menu**. To change the IDE options go to **Help | Edit Custom Properties*

# Expected Results & Benchmarks
**Note that this example is the orange one (sophisticated)**

<img src="https://docs.google.com/spreadsheets/d/1iN6_z2HfJPsGPKlNzwgnUxps4MT5BxhUbOuhwXdnIgI/pubchart?oid=1400772564&format=image"/>

<img src="https://docs.google.com/spreadsheets/d/1iN6_z2HfJPsGPKlNzwgnUxps4MT5BxhUbOuhwXdnIgI/pubchart?oid=93956661&format=image"/>

<img src="https://docs.google.com/spreadsheets/d/1iN6_z2HfJPsGPKlNzwgnUxps4MT5BxhUbOuhwXdnIgI/pubchart?oid=2053860050&format=image"/>

# Even More Performance (RAMDISK)

If you still want even more indexing and startup performance. Then mounting a RAM Disk and symlinking all caching data is the ultimate powerhouse

