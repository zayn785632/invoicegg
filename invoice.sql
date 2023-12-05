declare 
   l_result clob;
begin
htp.p('<div id="PrintArea">');
htp.p(' <div id="pos">
        <div class="gg">
            <img src="https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRqDBz2fbH-hfEXEgJj7wG9APTOvkDxv4cXo6vvpJqu0vuLq7Lw" width=80px;>
         <div class="bottom-left"><p>The Neko Shop</p></div>   
       
        </div>
        
        <div class="gg1"> <p> ur address <br>
                  ..,Bangladesh 
        <p>
                
            </div>  <br> ');

 FOR X IN (SELECT (SELECT SUPP_NAME FROM SUPPLIER_INFO WHERE ID=PO_SUPP) SUPP_NAME,
                           (SELECT A.ADDRESS1 FROM SUPPLIER_INFO A WHERE A.ID=PO_ORDER.PO_SUPP) ADDRESS,
                           (SELECT B.EMAIL FROM SUPPLIER_INFO B WHERE B.ID=PO_ORDER.PO_SUPP) E_MAIL,
                      PO_ID,CREATE_ON
                      FROM PO_ORDER WHERE PO_NO=:P13_ID)
LOOP
htp.p('<h2 class="hrline">INVOICE</h2>');
htp.p(' <div class="supcon">
        <div class="supleft">
            <p><strong>Supplier Name:</strong> <br> 
              <span> '||X.SUPP_NAME|| '</span><br> 
              <span> '||X.ADDRESS|| '</span> <br>
              <span> '||X.E_MAIL|| '</span> <br> 
            </p>
        </div>');
        HTP.P('<div class="supright">
            <table>
                <tr >
                    <td id="colorgg"><b>Invoice#</b></td>
                    <td>INV- '|| X.PO_ID  ||'</td>
                </tr>
                <tr>
                    <td id="colorgg"><b>Invoice Date:</b></td>
                    <td>'|| X.CREATE_ON  ||'</td>
                </tr>
            </table>
        </div>
    </div> <br> <br> <br>');
        END LOOP;

    l_result := l_result ||'
                <style>
                   
                    .table1, td {
                        border-bottom: 2px solid gray;
                        border-collapse: collapse;
                        text-align:left;
                        padding-top:5px;
                        padding-bottom:20px;
                    }
                    .thtb1{
                        -- background-color: black;
                        border-bottom: 2px solid gray;
                        border-collapse: collapse;
                        
                        
                        
                        
                    }
                    
                     #pos{
            position: relative;
        }
        .gg{
            
            
            float: left;
        }
      
        .gg1{
            
            float: right;
            font-size: 14px;
            padding-top:10px;
        }

        .bottom-left{
            position: absolute;
            top: 78px;
            left: 23px;
            font-size: 30px;
            font-style: italic;
            text-align: left;
            color: #6272A4;
            font-weight: bolder;
            font-size: 29px;
            
        }
        .hrline{
    display: flex; 
    flex-direction: row; 
    margin-top: 80px;
    
}
.hrline{
    font-weight: bold;
}
.hrline:before,
.hrline:after{
    content: ""; 
            flex: 1 1; 
            border-bottom: 2.5px solid #752475; 
            margin: auto; 
}
.supright{
    float: right;
    

}
.supleft{
    float: left;
}
.supright table tr td{
    border: none;
    border-collapse: collapse;
    border-spacing:10px;
    text-align:right;

}
.supright td{
    padding:0 30px;
    padding-bottom: 10px;

}
#colorgg{
    -- background-color: aquamarine;
    text-align:left;
    
}
.para{
    text align:left;
    font-size:14px;
    color: #555;
    line-height:0.5;
}
.terms{
     text align:left;
    font-size:14px;
    color: #555;
    line-height:0.5;
}
.transpose{
    border-collapse: collapse;
    margin-bottom: 24px;
    border: none;
    padding:5px;
    margin-right:28px;

    
}
.transpose thead,
.transpose tbody,
.transpose tr {
    display: inline-block;
    border: none;
    width: 50%;

}
.transpose tbody td {
    padding: 0px 0px 10px 0px;
}
.transpose tbody tr {
    margin-right: -.27em;
    border: none;

}
.transpose th,
.transpose td {
    display: block;
    border: none;
    padding: 0 37px;
    padding-bottom: 10px;
    
}
/*------right------*/
.transpose td {
        text-align:right;
   
}
                </style>
                <table class="table1" style="width: 100%;">
                          <thead>
                            <tr>
                                
                                <th class="thtb1">ITEM NAME</th>
                                <th class="thtb1" >RATE</th>
                                <th class="thtb1" >QUANTITY</th>
                                <th class="thtb1" >AMOUNT</th>
                            </tr>
                        </thead>
                        <tbody>';
    for i in(
             SELECT ID,
                    PO_NO,
                    (SELECT A.ITEM_NAME FROM ITEM_MST A WHERE A.ID =PO_DTL.ITEM_NAME) ITEM,
                    RATE,
                    QTY
                    
             FROM PO_DTL
             where PO_NO=:P13_ID
    
    )

    loop

                  l_result := l_result ||'
                                <tr>
                                    <td>'|| i.ITEM ||'</td>
                                    <td>'|| i.RATE ||'</td>  
                                    <td>'|| i.QTY ||'</td>  
                                    <td>'|| i.RATE*i.QTY ||'</td>  
                                </tr>';
        
    end loop;
   
    l_result := l_result || '
                        </tbody>
                        </table> <br> ';

    -- total code   
                     
   l_result := l_result ||'
                
            <table class="transpose" style="width: 50%; float:right;">
                          <thead>
                            <tr  >
                                <th >SUBTOTAL</th>
                                <th >DISCOUNT</th> 
                                <th >VAT(%)</th>
                                <th >TOTAL</th>
                            </tr>
                        </thead>
                        <tbody>';
      
    for a in(
             SELECT PO_NO,
                    AMOUNT,
                    DISCOUNT,
                    VAT,
		            NET_AMOUNT
             FROM PO_ORDER
             where PO_NO=:P13_ID
    
    )

    loop


                   l_result := l_result ||'
                                <tr>
                                    <td >'|| a.AMOUNT ||'</td>
                                    <td >-'|| a.DISCOUNT ||'</td>
                                    <td >'|| a.VAT ||'%</td>  
                                    <td >'|| a.NET_AMOUNT ||'</td>  
                                </tr>';
        
    end loop;
   
    l_result := l_result || '
                        </tbody>
                        </table> <br> <br> <br>
                        
                        ';
          
--  total code ends here

l_result := l_result || '
                        </tbody>
                        </table>
                        <div class="para">
                        <p>Notes<p>
                        <p>It was great doing business with you.<p>
                        </div> <br>
                        <div class="terms">
                        <p>Terms & Conditions<p>
                        <p>Upon accepting this purchase order, you hereby agree to the terms & conditions.<p>
                        </div>
                        
                        ';

    return l_result;
htp.p('</div>');
 
end;

