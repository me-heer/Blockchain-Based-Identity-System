<%-- 
    Document   : UploadFile
    Created on : 25 Feb, 2020, 2:21:43 AM
    Author     : mformihir
--%>

<%@page import="org.web3j.protocol.core.RemoteFunctionCall"%>
<%@page import="org.web3j.protocol.core.methods.response.TransactionReceipt"%>
<%@page import="org.web3j.tx.gas.DefaultGasProvider"%>
<%@page import="org.web3j.crypto.Credentials"%>
<%@page import="io.ipfs.api.IPFS"%>
<%@page import="org.web3j.protocol.core.methods.response.EthGasPrice"%>
<%@page import="org.web3j.protocol.core.methods.response.EthBlockNumber"%>
<%@page import="org.web3j.protocol.core.methods.response.Web3ClientVersion"%>
<%@page import="org.web3j.protocol.http.HttpService"%>
<%@page import="org.web3j.protocol.Web3j"%>
<%@page import="io.ipfs.api.MerkleNode"%>
<%@page import="io.ipfs.api.NamedStreamable"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<<%@ page import = "java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>
<%@page import="com.mihir.javaheroku.HelloWorld"%>

<%@ page import = "java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import = "javax.servlet.http.*" %>
<%@ page import = "org.apache.commons.fileupload.*" %>
<%@ page import = "org.apache.commons.fileupload.disk.*" %>
<%@ page import = "org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "org.apache.commons.io.output.*" %>

<%!
    static IPFS ipfs = new IPFS("127.0.0.1", 5001);

%>

<%
    File file;
    int maxFileSize = 5000 * 1024;
    int maxMemSize = 5000 * 1024;
    ServletContext context = pageContext.getServletContext();
    String filePath = context.getInitParameter("file-upload");

    // Verify the content type
    String contentType = request.getContentType();

    if (contentType != null)
        if ((contentType.indexOf("multipart/form-data") >= 0)) {
            DiskFileItemFactory factory = new DiskFileItemFactory();
            // maximum size that will be stored in memory
            factory.setSizeThreshold(maxMemSize);

            // Location to save data that is larger than maxMemSize.
            factory.setRepository(new File("c:\\temp"));

            // Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);

            // maximum file size to be uploaded.
            upload.setSizeMax(maxFileSize);

            try {
                // Parse the request to get file items.
                List fileItems = upload.parseRequest(request);

                // Process the uploaded file items
                Iterator i = fileItems.iterator();

                out.println("<html>");
                out.println("<head>");
                out.println("<title>JSP File upload</title>");
                out.println("</head>");
                out.println("<body>");

                while (i.hasNext()) {
                    FileItem fi = (FileItem) i.next();
                    if (!fi.isFormField()) {
                        // Get the uploaded file parameters
                        String fieldName = fi.getFieldName();
                        String fileName = fi.getName();
                        boolean isInMemory = fi.isInMemory();
                        long sizeInBytes = fi.getSize();

                        // Write the file
                        if (fileName.lastIndexOf("\\") >= 0) {
                            file = new File(filePath
                                    + fileName.substring(fileName.lastIndexOf("\\")));
                        } else {
                            file = new File(filePath
                                    + fileName.substring(fileName.lastIndexOf("\\") + 1));
                        }
                        fi.write(file);
                        out.println("Uploaded Filename: " + filePath
                                + fileName + "<br>");

                        //NamedStreamable.InputStreamWrapper is = new NamedStreamable.InputStreamWrapper(
                        //    new FileInputStream("/home/mformihir/Desktop/Advanced-Java-Assignments-master/src/main/webapp/xyz.txt"));
                        NamedStreamable.InputStreamWrapper is = new NamedStreamable.InputStreamWrapper(
                                new FileInputStream(filePath + "/" + fileName));

                        MerkleNode responseM = ipfs.add(is).get(0);
                        out.println("Hash (base 58): " + responseM.name.get());
                        String hash = responseM.name.get();
                        
                        //IPFS Starts here
                        out.println("Connecting to Ethereum ...");
                        Web3j web3 = Web3j.build(new HttpService("http://127.0.0.1:7545"));
                        out.println("Successfuly connected to Ethereum");
                        // web3_clientVersion returns the current client version.
                        Web3ClientVersion clientVersion = web3.web3ClientVersion().send();

                        // eth_blockNumber returns the number of most recent block.
                        EthBlockNumber blockNumber = web3.ethBlockNumber().send();

                        // eth_gasPrice, returns the current price per gas in wei.
                        EthGasPrice gasPrice = web3.ethGasPrice().send();

                        // Print result
                        out.println("Client version: " + clientVersion.getWeb3ClientVersion());
                        out.println("Block number: " + blockNumber.getBlockNumber());
                        out.println("Gas price: " + gasPrice.getGasPrice());
                        
                        Credentials creds = Credentials.create("9a9823e63de5a6659e1d8bccf4ecf37c61e041a5306acb87a4c97ec540dbc068");
                        //HelloWorld registryContract = HelloWorld.deploy(web3, creds, new DefaultGasProvider()).send();
                        HelloWorld registryContract = HelloWorld.load("0x0DCd2F752394c41875e259e00bb44fd505297caF",web3, creds, new DefaultGasProvider());
                        String contractAddress = registryContract.getContractAddress();  
                        out.println(contractAddress);
                        
                        TransactionReceipt receipt = registryContract.setHash(hash).send();
                        String tx = receipt.getTransactionHash().toString();
                        
                    }
                }
                out.println("</body>");
                out.println("</html>");
            } catch (Exception ex) {
                System.out.println(ex);
            }
        } else {
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet upload</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<p>No file uploaded</p>");
            out.println("</body>");
            out.println("</html>");
        }
%>

<html>
    <head>
        <meta charset="utf-8" />
        <meta name="author" content="Denis Samardjiev" />
        <meta name="description" content="Particles - Personal + Agency Template">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Upload</title>

        <!-- Royal Preloader CSS -->
        <link href="css/royal_preloader.css" rel="stylesheet">

        <!-- jQuery Files -->
        <script type="text/javascript" src="ajax/libs/jquery/3.1.0/jquery.min.js"></script>

        <!-- Parallax File -->
        <script type="text/javascript" src="js/parallax.min.js"></script>

        <!-- Royal Preloader -->
        <script type="text/javascript" src="js/royal_preloader.min.js"></script>
        <script type="text/javascript">
            Royal_Preloader.config({
                mode: 'number',
                showProgress: false,
                background: '#1d1d1d'
            });
        </script>

        <!-- Stylesheets -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/ionicons.min.css" rel="stylesheet">
        <link href="css/pe-icon-7-stroke.css" rel="stylesheet">
        <link href="css/magnific-popup.css" rel="stylesheet">
        <link href="css/logoiconfont.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet" title="main-css">

        <!-- Style Switcher / remove for production -->
        <link href="css/style-switcher.css" rel="stylesheet">

        <!-- Alternate Stylesheets / choose what color and base you want and include the 2 files regularly AFTER style.css above -->
        <link rel="alternate stylesheet" type="text/css" href="css/colors/blue.css" title="blue">
        <link rel="alternate stylesheet" type="text/css" href="css/colors/green.css" title="green">
        <link rel="alternate stylesheet" type="text/css" href="css/colors/orange.css" title="orange">
        <link rel="alternate stylesheet" type="text/css" href="css/colors/red.css" title="red">
        <link rel="alternate stylesheet" type="text/css" href="css/colors/orangelight.css" title="orangelight">
        <link rel="alternate stylesheet" type="text/css" href="css/colors/pinkish.css" title="pinkish">
        <link rel="alternate stylesheet" type="text/css" href="css/colors/seagul.css" title="seagul">
        <link rel="alternate stylesheet" type="text/css" href="css/base-light.css" title="base-light">
    </head>

    <body class="royal_preloader" data-spy="scroll" data-target=".navbar" data-offset="70">
        <div id="royal_preloader"></div>
        <!-- Begin Header -->
        <header>
            <!-- Begin Navigation -->
            <nav class="navbar navbar-default navbar-fixed-top">
                <div class="container-fluid">
                    <div class="row">
                        <!-- Brand and toggle get grouped for better mobile display -->
                        <div class="navbar-header">
                            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                                <span class="sr-only">Toggle navigation</span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                            </button>
                            <a class="navbar-brand scroll-link" href="#home" data-id="home"><span class="icon-handle-streamline-vector logo"></span></a>
                        </div>

                        <!-- Collect the nav links, forms, and other content for toggling -->
                        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                            <ul class="nav navbar-nav navbar-right">
                                <li><a href="index.html" data-id="home">Home</a></li>
                                <li><a href="login.html" data-id="ideology">Login</a></li>
                                <li><a href="signup.html" data-id="services">Sign Up</a></li>
                                <li><a href="#about" data-id="about">About</a></li>
                                <li><a href="#work" data-id="work">Work</a></li>
                                <li><a href="#team" data-id="team">Team</a></li>
                                <li><a href="#contact" data-id="contact">Contact</a></li>

                            </ul>
                        </div>

                    </div>
                </div>

            </nav>

        </header>

        <div class="jumbotron jumbotron-main" id="home">
            <div id="particles-js"></div>
            <!-- /.particles div -->
            <div class="container center-vertically-holder">
                <div class="center-vertically">
                    <div class="col-sm-8 col-sm-offset-2 col-lg-6 col-lg-offset-3 text-center">
                        <h1 class="scaleReveal">
                            Blockchain
                        </h1>
                        <hr class="bottomReveal">

                        <a href="#ideology" data-id="ideology" class="scroll-link">
                            <div class="scroll-indicator rotateBottomReveal">
                                <span class="ion-mouse"></span><br>
                                <span class="ion-android-arrow-down arrow-scroll-indicator"></span>
                            </div>
                        </a>
                    </div>
                    <!-- /.column -->
                </div>
                <!-- /.vertical center -->
            </div>
            <!-- /.container -->
        </div>
        <!-- End Jumbotron -->



        <section id="contact" class="background2 section-padding">
            <div class="container">
                <div class="row mb30">
                    <div class="col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2 col-lg-6 col-lg-offset-3 section-title text-center">
                        <h2>Login</h2>
                        <span class="section-divider mb15"></span>
                    </div>
                    <!-- /.column -->
                </div>
                <div class="row">

                    <div class="col-sm-6 col-lg-7 mt30-xs">
                        <form enctype = "multipart/form-data"   name="UploadFile" action="UploadFile.jsp" method="POST">

                            <!-- /.row -->
                            <div class="row mb10">
                                <!-- /.column -->
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <div class="controls">
                                            <input class="form-control" data-error="This section is required." name="upload" size="50" type="file">
                                            <div class="help-block with-errors"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /.row -->

                            <div class="row mt15">

                                <!-- /.column -->
                                <div class="col-sm-6 text-right">
                                    <input type="submit" value="Upload File" class="btn btn-default btn-lg">
                                </div>
                                <!-- /.column -->
                            </div>
                            <!-- /.row -->
                        </form>
                        <!-- /.form -->
                    </div>
                    <!-- /.column -->
                </div>
                <!-- /.row -->
            </div>
            <!-- /.container -->
        </section>

        <!-- Javascript Files -->
        <script type="text/javascript" src="js/bootstrap.min.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyArLNT3t4qsJEBmR0R9P_6ueLIQz0Jvt1M&amp;callback=initMap" async defer></script>

        <script type="text/javascript" src="js/particles.min.js"></script>
        <script type="text/javascript" src="js/particlesRun.js"></script>
        <script type="text/javascript" src="js/jquery.mixitup.js"></script>
        <script type="text/javascript" src="js/form-validator.min.js"></script>
        <script type="text/javascript" src="js/jquery.inview.min.js"></script>
        <script type="text/javascript" src="js/jquery.countTo.js"></script>
        <script type="text/javascript">
            /* ---- Counter (our count) ---- */
            $('#ourcount').one('inview', function (event, isInView) {
                if (isInView) {
                    $('.timer').countTo({
                        speed: 3000
                    });
                }
            });
        </script>
        <script type="text/javascript" src="js/jquery.magnific-popup.min.js"></script>
        <script type="text/javascript" src="js/scrollreveal.min.js"></script>
        <script type="text/javascript" src="js/style-switcher.js"></script>
        <!-- Remove for production -->
        <script type="text/javascript" src="js/main.js"></script>


    </body>

</html>