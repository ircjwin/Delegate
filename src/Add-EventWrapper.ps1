function Add-EventWrapper {
    <#
    .SYNOPSIS
       Wrap an event handler to preserve class instance
    .DESCRIPTION
       This function invokes a script block or method within a new closure of curly
       braces, preserving the invocation before the event is raised. This prevents
       contamination of automatic variable $this and allows the script block or
       method to reference a class instance. Without this function, $this references
       the event sender.
    .PARAMETER Method
       Class method that handles an event
    .PARAMETER ScriptBlock
       Script block that handlees an event
    .PARAMETER SendArgs
       Values from automatic variable $Args are preserved
    .NOTES
       This function is adapted from code written by user mklement0 on Stack Overflow.
       See LINK for reference.
    .LINK
       https://stackoverflow.com/a/64236498
    #>
        param (
            [Parameter()]
            [PSMethod] $Method,
            [Parameter()]
            [ScriptBlock] $ScriptBlock,
            [Parameter()]
            [Switch] $SendArgs
        )
        $Block = {}
        if ($Method) {
            if ($SendArgs) {
                $Block = { $Method.Invoke( $Args[0], $Args[1] ) }.GetNewClosure()
            } else {
                $Block = { $Method.Invoke() }.GetNewClosure()
            }
        }
        if ($ScriptBlock) {
            if ($SendArgs) {
                $Block = { $ScriptBlock.Invoke($Args) }.GetNewClosure()
            } else {
                $Block = { $ScriptBlock.Invoke() }.GetNewClosure()
            }
        }
        return $Block
    }