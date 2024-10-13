Add-Type -AssemblyName System.Windows.Forms

# Function to create a bouncing form
function Create-BouncingForm {
    param (
        [string]$imagePath,
        [hashtable]$state
    )

    function createForm {
        param([int]$Left, [int]$Top)
        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Bouncing Form"
        $form.StartPosition = "CenterScreen"
        $form.TransparencyKey = $form.BackColor
        $form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
        $form.ControlBox = $false
        $form.ShowIcon = $false
        $form.TopMost = $true
        $form.ShowInTaskbar = $false
        $form.MinimumSize = [System.Drawing.Size]::Empty 
        $form.Left = $Left

        $image = [System.Drawing.Image]::FromFile($imagePath)

        $form.ClientSize = New-Object System.Drawing.Size($image.Width, $image.Height)
        $form.BackgroundImage = $image
        $form.BackgroundImageLayout = [System.Windows.Forms.ImageLayout]::Stretch

        return $form
    }

    $form = createForm -Left 0 -Top 0
    

    # Create a timer
    $timer = New-Object System.Windows.Forms.Timer
    $timer.Interval = 10  

    # Add tick event handler
    $timer.Add_Tick({
        $screenBounds = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea

        # Move the form
        $form.Left += $state.dx
        $form.Top += $state.dy

        # Check for boundary collisions
        if ($form.Left -le 0 -or ($form.Left + $form.Width) -ge $screenBounds.Width) {
            $state.dx = -$state.dx  
        }

        if ($form.Top -le 0 -or ($form.Top + $form.Height) -ge $screenBounds.Height) {
            $state.dy = -$state.dy  
        }

        # Check mouse position
        $mousePos = [System.Windows.Forms.Control]::MousePosition
        if ($form.Bounds.Contains($mousePos)) {

           Create-BouncingForm -imagePath $imagePath -state @{ dx = $state.dx+1; dy = $state.dy+1}
        }
    })

    $timer.Start()
    $form.ShowDialog()

}

$imagePath = "./skibidi.png"

$initialState = @{ dx = 1; dy = 1 }

# Create the initial bouncing form
Create-BouncingForm -imagePath $imagePath -state $initialState
