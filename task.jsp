<%@ page import="java.sql.*" %> 
<%@ page import="java.io.*" %>
<%@ page import="java.lang.*" %> 
<%@ page import="java.util.Random" %>
<html>
   <head>
      <title>Online Fund Transaction</title>
   </head>
   <body style="background-image:url('img.jpg'); background-size: cover;">
      <ul>
      <% int acNo= Integer.parseInt(request.getParameter("Acnum"));%>
         <li><p><b>Account No:</b>
            <%= acNo%>
         </p></li>
      </ul>
   <%
 try{
   String connectionURL = "jdbc:mysql://localhost:3306/vinod90"; 
   Connection connection = null; 
   Class.forName("com.mysql.jdbc.Driver"); 
   connection = DriverManager.getConnection(connectionURL, "vinod90", "doniv90");
   Statement stmt=connection.createStatement();
   try{ResultSet r=stmt.executeQuery("select AMOUNT from ACCOUNTS where ACCOUNTNO='"+acNo+"'");
   r.next();
   if(r.getInt("AMOUNT")>=1000){
   stmt.executeUpdate("update ACCOUNTS set AMOUNT=AMOUNT-1000 where ACCOUNTNO='"+acNo+"'"); 
   Timestamp timestamp = new Timestamp(System.currentTimeMillis());
   String x="$1000 debited";
   ResultSet m=connection.createStatement().executeQuery("select AMOUNT from ACCOUNTS where ACCOUNTNO='"+acNo+"'");
   m.next();
   int avabal=m.getInt(1);
   stmt.executeUpdate("insert into transactions values('"+acNo+"','"+new Random().nextInt(Integer.MAX_VALUE)+"','"+timestamp+"','"+x+"','"+avabal+"')");
   ResultSet resultSet=stmt.executeQuery("SELECT * FROM transactions where ACCOUNTNO='"+acNo+"' ORDER BY Timpe_Stamp DESC LIMIT 5");
   %>
   <table border="1">
<tr>
<td><b>Transactin_ID</b></td>
<td><b>TimeStamp</b></td>
<td><b>Transaction</b></td>
<td><b>Avail_Bal</b></td>
</tr>
<%while(resultSet.next()){%>
<tr>
<td><%=resultSet.getInt("TransId") %></td>  
<td><%=resultSet.getTimestamp(3) %></td>
<td style="color:red"><%=resultSet.getString(4) %></td>
<td><%=resultSet.getInt(5) %></td>
</tr><% }%>
</table><br>
<%m=stmt.executeQuery("select AMOUNT from ACCOUNTS where ACCOUNTNO='"+acNo+"'");
  m.next();%><h3 style="color:green">Availble Balanace&nbsp;&nbsp;&nbsp;&nbsp;<%=+m.getInt(1)%>/-</h3>
  <%} 
  else{out.println("Insuffient Fund in your account discovered!!!");}
   }catch(Exception ex){%><h2 style="color:red"> Account number does not exits in datebase!!!! </h2><%}
}catch(Exception ex){%>
<h2 style="color:red">Unable to connect  databse!!!!</h2>
<%}%>
</body>
</html>