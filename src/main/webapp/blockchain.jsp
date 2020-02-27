
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="org.web3j.crypto.Credentials" %>
<%@page import="org.web3j.protocol.Web3j" %>
<%@page import="org.web3j.protocol.core.RemoteCall" %>
<%@page import="org.web3j.protocol.core.methods.response.EthBlockNumber" %>
<%@page import="org.web3j.protocol.core.methods.response.EthGasPrice" %>
<%@page import="org.web3j.protocol.core.methods.response.Web3ClientVersion" %>
<%@page import="org.web3j.protocol.http.HttpService" %>
<%@page import="org.web3j.tx.gas.DefaultGasProvider" %>

<%@page import="java.io.FileWriter" %>
<%@ page import="org.web3j.crypto.Credentials" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.IOException" %>
<%@ page import="org.web3j.protocol.Web3j" %>
<%@ page import="org.web3j.protocol.http.HttpService" %>
<%@ page import="org.web3j.protocol.core.methods.response.EthBlockNumber" %>
<%@ page import="org.web3j.protocol.core.methods.response.EthGasPrice" %>
<%@ page import="org.web3j.protocol.core.methods.response.Web3ClientVersion" %>
<%@ page import="io.ipfs.api.IPFS" %>
<%@ page import="io.ipfs.api.*" %>


<html>
<head>
    <title>Upload form</title>
    <meta charset="UTF-8"/>
    <link href="css/uploadFormUI.css" rel="stylesheet"/>
    <link href='https://fonts.googleapis.com/css?family=Varela+Round|Nunito:400,300,700' rel='stylesheet'
          type='text/css'>
    <script src="first.js" type="text/javascript"></script>

    <script type="text/javascript" src="IPFS.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
    <link href="https://fonts.googleapis.com/css?family=Open+Sans" rel="stylesheet">
    <style>
        .aadhar,
        .drivingLicense,
        .panCard {
            display: none;
        }
    </style>
</head>
<body>
<div class="container">

    <div class="form__container">
        <h1 class="form__title">Upload Documents</h1>

        <div>
            <fieldset class="section is-active">
                <legend>Select Documents</legend>
                <div class="form-row rw cf">
                    <div class="form-control four col">
                        <input type="checkbox" id="myCheck" onclick="selectDocuments()"/>
                        <label for="myCheck">
                            <h4>Aadhar</h4>
                        </label>
                    </div>
                    <div class="form-control four col">
                        <input type="checkbox" id="myCheck2" onclick="selectDocuments()"/>
                        <label for="myCheck2">
                            <h4>Pan Card</h4>
                        </label>
                    </div>
                    <div class="form-control four col">
                        <input type="checkbox" id="myCheck1" onclick="selectDocuments()"/>
                        <label for="myCheck1">
                            <h4>Driving License</h4>
                        </label>
                    </div>
                    <div class="form-control four col">
                        <input type="checkbox" id="myCheck2" onclick="selectDocuments()"/>
                        <label for="myCheck3">
                            <h4>Driving License</h4>
                        </label>
                    </div>
                    <div class="form-control four col">
                        <input type="checkbox" id="myCheck2" onclick="selectDocuments()"/>
                        <label for="myCheck4">
                            <h4>Driving License</h4>
                        </label>
                    </div>
                </div>
            </fieldset>
        </div>
        <div class="about_you">
            <form name="form1">
                <fieldset>
                    <legend>About You</legend>

                    <div class="form-row">
                        <div class="form-control">
                            <label>Name</label>
                            <input type="text" class="aboutyoufield" placeholder="What's your name?"
                                   required="required"/>
                        </div>
                        <div class="form-control">
                            <label>DOB</label>
                            <input type="date" class="aboutyoufield" required/>
                        </div>
                        <div class="form-control">
                            <label>Email</label>
                            <input type="text" class="aboutyoufield" placeholder="hello@email.com" required/>
                        </div>
                        <div class="form-control">
                            <label>Phone</label>
                            <input type="text" class="aboutyoufield" placeholder="555 555 5555" required/>
                        </div>
                    </div>

                </fieldset>
                <fieldset>

                    <div class="form-row">
                        <div class="form-control">
                            <label>Address</label>
                            <textarea></textarea>
                        </div>
                        <div class="form-control">
                            <label>Permanent Address</label>
                            <label>
                                <textarea></textarea>
                            </label>
                        </div>
                    </div>
                    <!--/.form-row-->
                </fieldset>
        </div>
        <div class="aadhar">
            <fieldset>
                <legend>Aadhar Details</legend>
                <div class="form-row">

                    <div class="form-control">
                        <label>Aadhar No.</label>
                        <input type="text" placeholder="Aadhar Number"/>
                    </div>
                    <div class="form-control">
                        <label>Aadhar Name</label>
                        <input type="text" placeholder="Aadhar Name"/>
                    </div>
                    <div class="form-control">
                        <label>State</label>
                        <select id="state">
                            <option value="" disabled selected>Select a state/province</option>
                            <option value="">MD</option>
                            <option value="VA">VA</option>
                            <option value="DC">DC</option>
                        </select>
                    </div>
                    <div class="form-control">
                        <label>City</label>
                        <select id="state">
                            <option value="" disabled selected>Select a state/province</option>
                            <option value="MD">MD</option>
                            <option value="VA">VA</option>
                            <option value="DC">DC</option>
                        </select>
                    </div>
                    <!--/.form-control-->
                </div>
                <!--/.form-row-->
            </fieldset>
        </div>
        <div class="panCard">
            <fieldset>
                <legend>Pan Card</legend>
                <div class="form-row">

                    <div class="form-control">
                        <label>PAN</label>
                        <input type="text" placeholder="Aadhar Number" name="aadhar_number"/>
                    </div>
                    <div class="form-control">
                        <label>Pancard Name</label>
                        <input type="text" placeholder="Aadhar Name" name="aadhar_name">
                    </div>
                    <div class="form-control">
                        <label>Validity</label>
                        <input type="date"/>
                    </div>
                    <div class="form-control">
                        <label>Date of First Issue</label>
                        <input type="date"/>
                    </div>
                    <div class="form-control">
                        <label>Blood Group</label>
                        <select id="state">
                            <option value="" disabled selected>Select a state/province</option>
                            <option value="">MD</option>
                            <option value="VA">VA</option>
                            <option value="DC">DC</option>
                        </select>
                    </div>
                    <div class="form-control">
                        <label>City</label>
                        <select id="state">
                            <option value="" disabled selected>Select a state/province</option>
                            <option value="MD">MD</option>
                            <option value="VA">VA</option>
                            <option value="DC">DC</option>
                        </select>
                    </div>
                    <!--/.form-control-->
                </div>
                <!--/.form-row-->
            </fieldset>
        </div>
        <div class="drivingLicense">
            <fieldset>
                <legend>Driving License</legend>
                <div class="form-row">

                    <div class="form-control">
                        <label>License No.</label>
                        <input type="text" placeholder="Aadhar Number"/>
                    </div>
                    <div class="form-control">
                        <label>License Name</label>
                        <input type="text" placeholder="Aadhar Name"/>
                    </div>
                    <div class="form-control">
                        <label>Validity</label>
                        <input type="date"/>
                    </div>
                    <div class="form-control">
                        <label>Date of First Issue</label>
                        <input type="date"/>
                    </div>
                    <div class="form-control">
                        <label>Blood Group</label>
                        <select id="state">
                            <option value="" disabled selected>Select a state/province</option>
                            <option value="">MD</option>
                            <option value="VA">VA</option>
                            <option value="DC">DC</option>
                        </select>
                    </div>
                    <div class="form-control">
                        <label>City</label>
                        <select id="state">
                            <option value="" disabled selected>Select a state/province</option>
                            <option value="MD">MD</option>
                            <option value="VA">VA</option>
                            <option value="DC">DC</option>
                        </select>
                    </div>
                    <!--/.form-control-->
                </div>
                <!--/.form-row-->
            </fieldset>
        </div>

        <!--/form-->
        <div class="form__buttons" id="nextbutton">
            <input type='submit' id="btn" name="button1" onclick="submitey()">Next</button>
        </div>
        </form>
        <!--/.form__buttons-->
    </div>
    <!--/.form__container-->
</div>

<%!
    static IPFS ipfs = new IPFS("127.0.0.1", 5001);
%>

<%
            
    if (request.getParameter("button1") == null) {
        try {
            
         
            NamedStreamable.InputStreamWrapper is = new NamedStreamable.InputStreamWrapper(
                    new FileInputStream("/home/mformihir/Desktop/Advanced-Java-Assignments-master/src/main/webapp/xyz.txt"));
            
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

        } catch (IOException ex) {
            throw new RuntimeException("Error whilst sending json-rpc requests", ex);
        }

    }

%>
</body>
</html>
