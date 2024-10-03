Describe 'Driver Script' {
    It 'Loads assemblies and launches Delegate' {
        . ./Driver.ps1 | Should -Not -Throw
    }
}