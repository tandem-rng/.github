! The four streams of cross-port/README.md from tandem-fortran. The workflow copies this file into
! the port's test/ directory and runs it with: fpm test cross_dump -- OUT
program cross_dump
    use, intrinsic :: iso_fortran_env, only: int32, int64, real32, real64
    use tandem_rng, only: tandem_t, tandem_new
    implicit none
    integer, parameter :: n = 1000000
    integer(int64), parameter :: starts(5) = [0_int64, 1_int64, 77_int64, 12345_int64, 2_int64**30]
    ! 3221225473 as the bits of an unsigned 32-bit bound.
    integer(int32), parameter :: wide_bound = -1073741823_int32
    character(len=4096) :: out
    integer(int32), allocatable :: u(:)
    real(real64), allocatable :: d(:)
    real(real32), allocatable :: f(:)
    type(tandem_t) :: g
    integer :: uniform, bounded, normal, exponential, i

    call get_command_argument(1, out)
    allocate (u(n), d(n), f(n))
    uniform = open_out("uniform.bin")
    bounded = open_out("bounded.bin")
    normal = open_out("normal.bin")
    exponential = open_out("exponential.bin")
    do i = 1, size(starts)
        g = at(starts(i))
        call g%fill(u)
        write (uniform) u
        call g%fill(d)
        write (uniform) d

        g = at(starts(i))
        call g%fill_below(u, 1000_int32)
        write (bounded) u
        call g%fill_below(u, wide_bound)
        write (bounded) u

        g = at(starts(i))
        call g%fill_normal(d)
        write (normal) d

        g = at(starts(i))
        call g%fill_exponential(d)
        write (exponential) d
        call g%fill_exponential(f)
        write (exponential) f
    end do
    close (uniform)
    close (bounded)
    close (normal)
    close (exponential)

contains

    function at(start) result(rng)
        integer(int64), intent(in) :: start
        type(tandem_t) :: rng
        rng = tandem_new(2026_int64, 7_int64)
        call rng%set_position(start)
    end function

    integer function open_out(name)
        character(len=*), intent(in) :: name
        open (newunit=open_out, file=trim(out)//"/"//name, access="stream", form="unformatted", &
            status="replace")
    end function

end program
