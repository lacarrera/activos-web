
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.Services
Imports System.Globalization
Imports System.Collections
Imports System.Configuration
Imports System.Linq
Imports System.Xml
Imports System.Xml.Linq
Imports System.Web
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.IO
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports iTextSharp.text.html
Imports iTextSharp.text.html.simpleparser
Imports iTextSharp.tool.xml
'Imports System.Drawing


Partial Class Captura_GenerarUID
    Inherits System.Web.UI.Page
    Private Sub Captura_GenerarUID_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.Cnx)
        Dim adp As New Data.SqlClient.SqlDataAdapter("", Funciones.Cnx)
        Dim dtSQL As New Data.DataTable
        Dim dt2 As New DataTable
        Dim contador As Integer = 0
        Dim renglon As Integer = 0


        dt2.Columns.Add("Col1")
        dt2.Columns.Add("QR1")
        dt2.Columns.Add("Col2")
        dt2.Columns.Add("QR2")
        dt2.Columns.Add("Col3")
        dt2.Columns.Add("QR3")
        dt2.Columns.Add("Col4")
        dt2.Columns.Add("QR4")
        'dt2.Columns.Add("Col5")
        'dt2.Columns.Add("QR5")
        'dt2.Columns.Add("Col6")
        'dt2.Columns.Add("QR6")

        adp.SelectCommand.CommandText = "Select RIGHT('0000000000' + Ltrim(Rtrim(UID)),10) as UID,CodigoQR from UIDs where UID <=50"
        adp.Fill(dtSQL)

        For Each linea As Data.DataRow In dtSQL.Rows
            Dim dr As DataRow = dt2.NewRow()
            contador = contador + 1

            Select Case contador
                Case 1
                    dr("Col1") = linea.Item("UID")
                    dr("QR1") = linea.Item("CodigoQR")
                    dt2.Rows.Add(dr)
                Case 2
                    dt2.Rows(renglon).Item(2) = linea.Item("UID")
                    dt2.Rows(renglon).Item(3) = linea.Item("CodigoQR")
                Case 3
                    dt2.Rows(renglon).Item(4) = linea.Item("UID")
                    dt2.Rows(renglon).Item(5) = linea.Item("CodigoQR")
                Case 4
                    dt2.Rows(renglon).Item(6) = linea.Item("UID")
                    dt2.Rows(renglon).Item(7) = linea.Item("CodigoQR")
                    renglon = renglon + 1
                    contador = 0
                    'Case 5
                    '    dt2.Rows(renglon).Item(8) = linea.Item("UID")
                    '    dt2.Rows(renglon).Item(9) = linea.Item("CodigoQR")
                    'Case 6
                    '    dt2.Rows(renglon).Item(10) = linea.Item("UID")
                    '    dt2.Rows(renglon).Item(11) = linea.Item("CodigoQR")

            End Select


        Next
        Session("SesQRS") = dt2
        GridView1.DataSource = dt2
        GridView1.DataBind()



    End Sub


    <WebMethod()>
    Public Shared Function UltimoUID() As String
        Dim qry, res As String
        Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.Cnx)
        Dim ultimo As Integer
        Try
            Funciones.AbrirBase(Funciones.Cnx)

            qry = "select Max(UID) from UIDs "
            cmd.CommandText = qry
            ' ultimo = cmd.ExecuteScalar()

            If Not IsDBNull(cmd.ExecuteScalar()) Then
                ultimo = cmd.ExecuteScalar()
                Return ultimo + 1
            Else
                Return 0 + 1
            End If

        Catch ex As Exception
            res = ex.Message.Replace("'", "")
        Finally
            Funciones.CerraBase(Funciones.Cnx)

        End Try



    End Function


    <WebMethod()>
    Public Shared Function GeneraUID(ByVal valor As Integer, imagen As String, inicio As Int16, fin As Int16) As String
        Dim qry, res As String
        Dim cmd As New Data.SqlClient.SqlCommand("", Funciones.Cnx)
        Dim uid As Integer
        Try
            Funciones.AbrirBase(Funciones.Cnx)

            qry = "select count(UID) from UIDs where UID =" & valor
            cmd.CommandText = qry
            uid = cmd.ExecuteScalar()

            If uid = 0 Then

                qry = "Insert into UIDs (UID,CodigoQR) Values (" & valor & ",'" & imagen & "')"
                cmd.CommandText = qry
                cmd.ExecuteNonQuery()

                res = "OK"

            Else
                res = "El Folio " & valor & " Y a fué generado anteriormente"
            End If
        Catch ex As Exception
            res = ex.Message.Replace("'", "")
        Finally
            Funciones.CerraBase(Funciones.Cnx)

        End Try

        Return res

    End Function

    Private Sub btn_pdf_Click(sender As Object, e As EventArgs) Handles btn_pdf.Click
        export_pdf1()

    End Sub

    Sub export_pdf()

        Dim dt As New DataTable
        dt = Session("SesQRS")
        Dim url_imagen As String
        Dim splits As String() = Request.Url.AbsoluteUri.Split("/"c)

        If splits.Length >= 2 Then
            Dim url As String = splits(0) & "//"
            For i As Integer = 2 To splits.Length - 3
                url += splits(i)
                url += "/"
            Next
            url_imagen = url + "estilos/fm_logo.png"
        End If


        Dim attachment As String = "attachment; filename=QRs.pdf"
        Response.ClearContent()
        Response.AddHeader("content-disposition", attachment)
        Response.ContentType = "application/pdf"
        Dim stw As New StringWriter()
        Dim htextw As New HtmlTextWriter(stw)
        Dim document As New Document()
        Dim writer As PdfWriter = PdfWriter.GetInstance(document, Response.OutputStream)


        Dim html As String = "<table width = '100%' border='1'>"

        If dt.Rows.Count > 0 Then
            For Each linea As Data.DataRow In dt.Rows
                '  html &= "<tr>"
                document.Open()



                If Not IsDBNull(linea.Item("Col1")) Then
                    Dim BarCodeTable As PdfPTable = New PdfPTable(1)




                    html &= "<tr><td rowspan='2' style='text-align:center;vertical-align:middle'>qr</td>"
                    html &= "<td style ='text-align:center;vertical-align:top;'> <img src='" & url_imagen & "' style='width:40%;height:auto;'/></td>"
                End If

                If Not IsDBNull(linea.Item("Col2")) Then
                    html &= "<td rowspan ='2' style='text-align:center;vertical-align:middle'>qr</td>"
                    html &= "<td style ='text-align:center;vertical-align:top;'> <img src='" & url_imagen & "' style='width:40%;height:auto;'/></td>"
                End If

                If Not IsDBNull(linea.Item("Col3")) Then
                    html &= "<td rowspan ='2' style='text-align:center;vertical-align:middle'>qr</td>"
                    html &= "<td style ='text-align:center;vertical-align:top;'> <img src='" & url_imagen & "' style='width:40%;height:auto;'/></td>"
                End If

                If Not IsDBNull(linea.Item("Col4")) Then
                    html &= "<td rowspan ='2' style='text-align:center;vertical-align:middle'>qr</td>"
                    html &= "<td style ='text-align:center;vertical-align:top;'> <img src='" & url_imagen & "' style='width:40%;height:auto;'/></td></tr><tr>"
                Else
                    html &= "</tr><tr>"
                End If

                If Not IsDBNull(linea.Item("Col1")) Then
                    html &= "<td style = 'text-align:center;vertical-align:top;'>" & linea.Item("Col1") & "</td>"
                End If

                If Not IsDBNull(linea.Item("Col2")) Then
                    html &= "<td style = 'text-align:center;vertical-align:top;'>" & linea.Item("Col2") & "</td>"
                End If

                If Not IsDBNull(linea.Item("Col3")) Then
                    html &= "<td style = 'text-align:center;vertical-align:top;'>" & linea.Item("Col3") & "</td>"
                End If

                If Not IsDBNull(linea.Item("Col4")) Then
                    html &= "<td style = 'text-align:center;vertical-align:top;'>" & linea.Item("Col4") & "</td></tr><tr>"
                Else
                    html &= "</tr><tr>"
                End If

                If Not IsDBNull(linea.Item("Col1")) Then
                    html &= "<td colspan='2' style='text-align:center;vertical-align:top;'>AF:12345678000ABCD</td>"
                End If

                If Not IsDBNull(linea.Item("Col2")) Then
                    html &= "<td colspan='2' style='text-align:center;vertical-align:top;'>AF:12345678000ABCD</td>"
                End If

                If Not IsDBNull(linea.Item("Col3")) Then
                    html &= "<td colspan ='2' style='text-align:center;vertical-align:top;'>AF:12345678000ABCD</td>"
                End If

                If Not IsDBNull(linea.Item("Col4")) Then
                    html &= "<td colspan = '2' style='text-align:center;vertical-align:top;'>AF:12345678000ABCD</td></tr>"
                Else
                    html &= "</tr>"
                End If

            Next
        End If

        html &= "</table>"




        'Dim attachment As String = "attachment; filename=QRs.pdf"
        'Response.ClearContent()
        'Response.AddHeader("content-disposition", attachment)
        'Response.ContentType = "application/pdf"
        'Dim stw As New StringWriter()
        'Dim htextw As New HtmlTextWriter(stw)
        '' GridView1.RenderControl(htextw)

        'Dim document As New Document()
        'Dim writer As PdfWriter = PdfWriter.GetInstance(document, Response.OutputStream)
        'document.Open()
        Dim sr As StringReader = New StringReader(html)
        Dim barcodeQRCode As BarcodeQRCode = New BarcodeQRCode("https://memorynotfound.com", 1000, 1000, Nothing)
        Dim codeQrImage As iTextSharp.text.Image = barcodeQRCode.GetImage()
        codeQrImage.scaleAbsolute(100, 100)
        document.Add(codeQrImage)
        ' Dim str As New StringReader(stw.ToString())

        'Add the Image file to the PDF document object.
        ' Dim img As iTextSharp.text.Image = iTextSharp.text.Image.GetInstance(filePath)
        ' document.Add(img)


        'Dim myString As String = stw.ToString()
        'myString = Replace(myString, "&lt;", "<")
        'myString = Replace(myString, "/&gt;", "/>")
        'myString = Replace(myString, "&quot;", """")

        'Dim str As New StringReader(myString)

        XMLWorkerHelper.GetInstance().ParseXHtml(writer, document, sr)
        'HTMLWorker.Parse(str)
        document.Close()
        Response.Write(document)
        Response.End()
    End Sub

    Sub export_pdf1()

        Dim dt As New DataTable
        dt = Session("SesQRS")
        Dim url_imagen As String
        Dim attachment As String = "attachment; filename=QRs.pdf"
        Response.AddHeader("content-disposition", attachment)
        Response.ContentType = "application/pdf"
        Dim stw As New StringWriter()
        Dim htextw As New HtmlTextWriter(stw)
        Dim document As New Document()
        Dim writer As PdfWriter = PdfWriter.GetInstance(document, Response.OutputStream)

        Dim splits As String() = Request.Url.AbsoluteUri.Split("/"c)
        If splits.Length >= 2 Then
            Dim url As String = splits(0) & "//"
            For i As Integer = 2 To splits.Length - 3
                url += splits(i)
                url += "/"
            Next
            url_imagen = url + "estilos/fm_logo.png"
        End If

        Dim logo As iTextSharp.text.Image = iTextSharp.text.Image.GetInstance(url_imagen)

        Dim tabla As PdfPTable = New PdfPTable(8)
        tabla.HorizontalAlignment = Element.ALIGN_CENTER
        Dim widths As Single() = New Single() {1.7F, 2.3F, 1.7F, 2.3F, 1.7F, 2.3F, 1.7F, 2.3F}
        tabla.SetWidths(widths)
        tabla.TotalWidth = 550.0F
        tabla.LockedWidth = True
        tabla.DefaultCell.Border = Rectangle.NO_BORDER
        ' tabla.DefaultCell.BorderColor = GrayColor


        If dt.Rows.Count > 0 Then
            For Each linea As Data.DataRow In dt.Rows

                Dim celda_qr1 As PdfPCell = New PdfPCell(New Phrase("código qr"))
                celda_qr1.Rowspan = 2
                celda_qr1.HorizontalAlignment = 1
                tabla.AddCell(celda_qr1)

                tabla.AddCell(logo)

                Dim celda_qr2 As PdfPCell = New PdfPCell(New Phrase("código qr2"))
                celda_qr2.Rowspan = 2
                celda_qr2.HorizontalAlignment = 1
                tabla.AddCell(celda_qr2)

                tabla.AddCell(logo)

                Dim celda_qr3 As PdfPCell = New PdfPCell(New Phrase("código qr3"))
                celda_qr3.Rowspan = 2
                celda_qr3.HorizontalAlignment = 1
                tabla.AddCell(celda_qr3)

                tabla.AddCell(logo)

                Dim celda_qr4 As PdfPCell = New PdfPCell(New Phrase("código qr4"))
                celda_qr4.Rowspan = 2
                celda_qr4.HorizontalAlignment = 1
                tabla.AddCell(celda_qr4)

                tabla.AddCell(logo)

                If Not IsDBNull(linea.Item("Col1")) Then
                    tabla.AddCell(linea.Item("Col1"))
                Else
                    tabla.AddCell("")
                End If

                If Not IsDBNull(linea.Item("Col2")) Then
                    tabla.AddCell(linea.Item("Col2"))
                Else
                    tabla.AddCell("")
                End If

                If Not IsDBNull(linea.Item("Col3")) Then
                    tabla.AddCell(linea.Item("Col3"))
                Else
                    tabla.AddCell("")
                End If

                If Not IsDBNull(linea.Item("Col4")) Then
                    tabla.AddCell(linea.Item("Col4"))
                Else
                    tabla.AddCell("")
                End If


                Dim cel_nombre1 As PdfPCell = New PdfPCell(New Phrase("NOMBRE ACTIVO 1"))
                cel_nombre1.Colspan = 2
                cel_nombre1.HorizontalAlignment = 1
                tabla.AddCell(cel_nombre1)

                Dim cel_nombre2 As PdfPCell = New PdfPCell(New Phrase("NOMBRE ACTIVO 2"))
                cel_nombre2.Colspan = 2
                cel_nombre2.HorizontalAlignment = 1
                tabla.AddCell(cel_nombre2)


                Dim cel_nombre3 As PdfPCell = New PdfPCell(New Phrase("NOMBRE ACTIVO 3"))
                cel_nombre3.Colspan = 2
                cel_nombre3.HorizontalAlignment = 1
                tabla.AddCell(cel_nombre3)

                Dim cel_nombre4 As PdfPCell = New PdfPCell(New Phrase("NOMBRE ACTIVO 4"))
                cel_nombre4.Colspan = 2
                cel_nombre4.HorizontalAlignment = 1
                tabla.AddCell(cel_nombre4)

                Dim cellBlankRow As PdfPCell = New PdfPCell(New Phrase(" "))
                cellBlankRow.Colspan = 8
                cellBlankRow.HorizontalAlignment = 1
                tabla.AddCell(cellBlankRow)
                'Dim cell_renglon As PdfPCell = New PdfPCell(New Phrase("XX"))
                'cell_renglon.Colspan = 8
                'cell_renglon.HorizontalAlignment = 1
                'tabla.AddCell(cell_renglon)

            Next

            tabla.HorizontalAlignment = 1
            document.Open()
            document.Add(tabla)

            document.Close()
            Response.Write(document)
            Response.End()
        End If
    End Sub



    Public Overloads Overrides Sub VerifyRenderingInServerForm(ByVal control As Control)
        ' Verifies that the control is rendered 
    End Sub

    Protected Function GetUrl(ByVal imagepath As String) As String

        Dim splits As String() = Request.Url.AbsoluteUri.Split("/"c)

        If splits.Length >= 2 Then

            Dim url As String = splits(0) & "//"

            For i As Integer = 2 To splits.Length - 3

                url += splits(i)

                url += "/"

            Next

            Return url + "estilos/fm_logo.png"

        End If

        Return "estilos/fm_logo.png"

    End Function
End Class
