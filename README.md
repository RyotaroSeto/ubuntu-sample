# ubuntu-sample

+ docker build -t ubuntu-sample:1.0 .
+ docker run -d -P --name test ubuntu-sample:1.0
+ docker port test 22
+ ssh hoge@localhost -p 55000
