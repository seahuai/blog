

### Fat Header

> /usr/include/mach-o/fat.h

#### 1. Fat header

```c
#define FAT_MAGIC_64	0xcafebabf
#define FAT_CIGAM_64	0xbfbafeca	/* NXSwapLong(FAT_MAGIC_64) */

struct fat_header {
	uint32_t	magic;		/* FAT_MAGIC or FAT_MAGIC_64 */
	uint32_t	nfat_arch;	/* number of structs that follow */
};
```

#### 2. Fat Archs

```c
struct fat_arch_64 {
	cpu_type_t	cputype;	/* cpu specifier (int) */
	cpu_subtype_t	cpusubtype;	/* machine specifier (int) */
	uint64_t	offset;		/* file offset to this object file */
	uint64_t	size;		/* size of this object file */
	uint32_t	align;		/* alignment as a power of 2 */
	uint32_t	reserved;	/* reserved */
};
```



### Mach-O

可以使用`otool -l excutable path`查看对应可执行文件的mach-o信息

#### 1. Header

> /usr/include/mach-o/loader.h
>
> 以下均为64位的情况

```c
/*
 * The 64-bit mach header appears at the very beginning of object files for
 * 64-bit architectures.
 */
struct mach_header_64 {
	uint32_t	magic;		/* mach magic number identifier */
	cpu_type_t	cputype;	/* cpu specifier */
	cpu_subtype_t	cpusubtype;	/* machine specifier */
	uint32_t	filetype;	/* type of file */
	uint32_t	ncmds;		/* number of load commands */
	uint32_t	sizeofcmds;	/* the size of all the load commands */
	uint32_t	flags;		/* flags */
	uint32_t	reserved;	/* reserved */
};
```

* Magic number

```c
/* Constant for the magic field of the mach_header_64 (64-bit architectures) */
#define MH_MAGIC_64 0xfeedfacf /* the 64-bit mach magic number */
#define MH_CIGAM_64 0xcffaedfe /* NXSwapInt(MH_MAGIC_64) */
```

* cputype & cpusubtype
  * define at /usr/include/mach/machine.h

#### 2. Load Commands

```c
struct load_command {
	uint32_t cmd;		/* type of load command */
	uint32_t cmdsize;	/* total size of command in bytes */
};
```

#### 3. Data

##### 1. Segement

>A segment is a grouping of memory that has specific permissions. A segment can have 0 or more subcomponents named sections.

typical segement

* `__PAGEZERO` Segement, is a section in memory that contains 0 sections;
* `__TEXT` Segement, stores readable and executable memory. 
  * Typically the __TEXT segment will have multiple sections for storing various immutable data.

* `__Data` Segement, stores readable and executable memory. 
  * Typically the __DATA segment will have multiple sections for storing various mutable data.

* `__LINKEDIT` Segement, is a grab-bag of content that only has readable permissions. 
  * This segment stores the symbol table, the entitlements file (if not on the Simulator), the codesigning information and other essential information that enables a program to function. Even though this segment has lots of important data packed inside, it has no sections.



使用 `image list -b -h` 输出所有加载的module，通过查看对应地址中的内存数据`x/8wx 0xaaaaaaaa..`，获取对应的mach-o header信息

##### 2. sections

Sections are sub-components found in a segment.

* `__TEXT__.cstring` section
  * This is where the UTF-8 hardcoded strings are stored for your print statements, key-value coding/observing, or anything else that's between "'s in your source code
* `__DATA.__objc_classlist` 
  * This section stores Class pointers to Objective-C or Swift classes. This section is an array of Class pointers that point to the actual Classes stored into `__DATA.__objc_data`
* `__DATA.__la_symbol_ptr`
  * This section is a rather interesting section as it stores references to external functions that are lazily resolved at runtime when called.
