<#

    This is a sample script to showcase how to create a new phishing email from html.

#>

# Start a web driver. Credentials will be prompted for on the console
$Driver = Start-Kb4Driver -Visible $TRUE

# Creates a new phishing template. Traditional placeholder variables are supported just like in the web console.
# If the IT category doesn't exist already, it will be created.
New-Kb4EmailTemplate -Driver $Driver -TemplateName "IT: Laptop Upgrade" -SenderEmail "IT@[[domain]]" -SenderName "IT Asset Support" -Subject "Laptop Upgrade" -HTMLContent @"
<div style="font-family: Arial; width:600px;">
<p>Hello [[first_name]],</p>

<p><x-sei title="Shocking content to entice you to click link or open attachment.">You're laptop is scheduled for replacement on [[current_date_2]]</x-sei>. To register to receive your new device, please fill out our <x-sei title="Hover over the link. Link does not take you to the site the email content says it will."><a class="plink" href="[[URL]]">new asset enrollment form</a></x-sei>.</p>

<p>Thank you,<br />
[[company_name]] IT Asset Support</p>
</div>
"@ -Category "IT"