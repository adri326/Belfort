# Character relationship visualization through graphs

## How it works:

The [original paper (French)](https://journals.openedition.org/resf/1183) describes in detail the technique that this software implements.

In short, it does the following:

- reads a `csv` file with the present of each character for each timewise unit (this usually corresponds to a page, a paragraph, a sequence, a minute, etc.)
- optionally reads up to two other `csv` files to describe one or two charactersitics of the characters
- creates an incidence graph based on the simultaneous presence of characters
- prunes out the characters that have little interaction / simultaneous presence
- produce a graph whose edges are weighted, based on the number of interactions had
- output such graph as a pdf file

## Usage

*Note: This repository is a fork of the original one and claims to be a cleaner version of it. If you are a student of M.Triclot, I recommend you use [the original repository](https://github.com/mtriclot/Belfort) instead.*

Clone this repository:

```sh
git clone https://github.com/adri326/character-graph
cd character-graph
```

Make sure to have [R](https://wiki.archlinux.org/index.php/R) installed and run the main script:

```sh
R -f main.R --args "Cloud Atlas" 5 data/2013.cloud_atlas-adj.csv data/2013.cloud_atlas-attr.csv
```

The syntax for running the main script as-is is:

```sh
R -f main.R --args <name> <threshold> <presence-file> [<property-1> [<property-2>]]
```

- `<threshold>` is the minimum number of simultaneous presence that a character must have (a value of 10 is usually enough to filter out most secondary "noise" characters)
- `<presence-file>` is the `csv` file describing the presence of each character at each given step
- `<property-1>` is the `csv` file describing the primary property of each character (will be transcribed as the color of their vertice)
- `<property-2>` is the `csv` file describing the secundary property of each character (will be transcribed as the shape of their vertice)
